resource "google_compute_router" "router" {
  count   = var.enable-advanced-features ? length(var.regions) : 0
  project = var.project-id
  name    = format("router-%s-%s", split("-", var.regions[count.index])[0], "${count.index}")
  region  = google_compute_subnetwork.subnet-for-l7lb[count.index].region
  network = google_compute_network.vpc-network[0].id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  count                              = var.enable-advanced-features ? length(var.regions) : 0
  project                            = var.project-id
  name                               = format("%s-nat-%s", split("-", var.regions[count.index])[0], var.regions[count.index])
  router                             = google_compute_router.router[count.index].name
  region                             = google_compute_router.router[count.index].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}