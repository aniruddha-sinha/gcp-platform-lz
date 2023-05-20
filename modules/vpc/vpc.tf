resource "google_compute_network" "vpc-network" {
  count                   = var.is-network-created ? 0 : 1
  project                 = var.project-id
  name                    = "vpc-${var.project-id}"
  auto_create_subnetworks = false
  mtu                     = 1460
}