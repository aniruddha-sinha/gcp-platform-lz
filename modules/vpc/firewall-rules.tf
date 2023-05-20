resource "google_compute_firewall" "allow-ssh" {
  project = var.project-id
  count   = length(var.regions) == 0 ? 0 : 1
  name    = format("fw-ssh-%s", google_compute_network.vpc-network[0].name)
  network = google_compute_network.vpc-network[0].id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = var.source-tags
  target_tags = var.target-tags
}

resource "google_compute_firewall" "gke_tcp" {
  project = var.project-id
  count   = length(var.regions) == 0 ? 0 : 1
  name    = format("fw-tcp-%s", google_compute_network.vpc-network[0].name)
  network = google_compute_network.vpc-network[0].id

  allow {
    protocol = "tcp"
    ports    = [ "10250", "443", "15017", "30805", "32454", "15021", "9080" ]
  }

  source_tags = var.source-tags
  target_tags = var.target-tags
}