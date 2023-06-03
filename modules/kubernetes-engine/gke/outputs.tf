output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "kubernetes_cluster_host" {
  value = google_container_cluster.gke_cluster.cluster_ipv4_cidr
}