module "vpc" {
  source = "./modules/vpc"

  project-id               = var.project_id
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}

module "iam" {
  source = "./modules/iam"

  project_id                   = var.project_id
  service_account_id           = "gke-node-sa"
  service_account_display_name = "GKE Node Service Account"
  role_list = [
    "roles/editor"
  ]
}

data "google_compute_network" "gke_network" {
  depends_on = [module.vpc, module.iam]
  name       = "vpc-${var.project_id}"
  project    = var.project_id
}

data "google_compute_subnetwork" "gke_subnetwork" {
  depends_on = [module.vpc, module.iam, data.google_compute_network.gke_network]
  name       = "subnet-us-0"
  project    = var.project_id
  region     = "us-central1"
}

data "google_container_engine_versions" "k8s_versions" {
  project  = var.project_id
  provider = google-beta
  location = "us-central1-a"
  #version_prefix = "1.23."
}

data "google_service_account" "custom_service_account" {
  depends_on = [module.vpc, module.iam]
  account_id = "gke-node-sa"
  project    = var.project_id
}

module "atlas" {
  depends_on   = [module.vpc, module.iam, data.google_service_account.custom_service_account]
  source       = "./modules/kubernetes-engine/gke"
  cluster_name = "atlas"
  project_id   = var.project_id
  location     = "us-central1-a"
  network      = data.google_compute_network.gke_network.name
  subnetwork   = data.google_compute_subnetwork.gke_subnetwork.name

  master_auth_config = {
    name    = "mac"
    ip_addr = "49.37.54.176/32"
  }

  kubernetes_version = data.google_container_engine_versions.k8s_versions.release_channel_default_version["STABLE"]

  node_config = {
    disk_size_gb = "50"
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    preemptible = true
    labels = {
      "usage" = "temp"
    }
    service_account = data.google_service_account.custom_service_account.name
  }

  node_pools = [
    {
      name               = "pool1"
      version            = data.google_container_engine_versions.k8s_versions.release_channel_default_version["STABLE"]
      initial_node_count = 2
      auto_repair        = true
      auto_upgrade       = true
      image_type         = "COS_CONTAINERD"
      machine_type       = "e2-medium"
      disk_type          = "pd-standard"
      disk_size_gb       = "50"
      service_account    = data.google_service_account.custom_service_account.name
      preemptible        = true
    }
  ]
}