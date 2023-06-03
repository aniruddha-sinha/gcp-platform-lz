output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "kubernetes_cluster_host" {
  value = google_container_cluster.gke_cluster.cluster_ipv4_cidr
}

output "client_certificate" {
  value = "${google_container_cluster.gke_cluster.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gke_cluster.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate}"
}