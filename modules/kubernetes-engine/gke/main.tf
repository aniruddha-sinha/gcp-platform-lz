locals {
  node_pool_names = [
    for node_pool in toset(var.node_pools) : node_pool.name
  ]
  node_pools = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))
}

resource "google_container_cluster" "gke_cluster" {
  provider                 = google-beta
  name                     = var.cluster_name
  project                  = var.project_id
  location                 = var.location
  initial_node_count       = 1
  remove_default_node_pool = true
  network                  = var.network
  subnetwork               = var.subnetwork
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  min_master_version       = var.kubernetes_version

  ip_allocation_policy {}

  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project_id)
  }

  network_policy {
    enabled = true
  }

  private_cluster_config {
    enable_private_endpoint = "false"
    enable_private_nodes    = "true"
    master_ipv4_cidr_block  = "172.16.0.16/28"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.cidr_blocks

      content {
        display_name = cidr_blocks.name
        cidr_block   = cidr_blocks.ip_addr
      }
    }
  }

  node_config {
    disk_size_gb = 50
    disk_type    = "pd-standard"
    machine_type = "e2-medium"
    preemptible  = true
  }
}

resource "google_container_node_pool" "gke_cluster_linux_node_pools" {
  provider           = google
  project            = var.project_id
  cluster            = google_container_cluster.gke_cluster.name
  for_each           = local.node_pools
  location           = google_container_cluster.gke_cluster.location
  name               = lookup(each.value, "name", "")
  version            = lookup(each.value, "node_pool_version", "") == "" ? google_container_cluster.gke_cluster.min_master_version : lookup(each.value, "node_pool_version", "")
  initial_node_count = lookup(each.value, "initial_node_count", 2)

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", true)
  }

  node_config {
    image_type      = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type    = lookup(each.value, "node_machine_type", "e2-medium")
    service_account = lookup(each.value, "node_service_account", "")
    preemptible     = lookup(each.value, "preemtible", true)
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_type    = lookup(each.value, "disk_type", "pd-standard")
    disk_size_gb = lookup(each.value, "disk_size_gb", "40")
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}
