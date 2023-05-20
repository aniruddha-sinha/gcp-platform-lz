resource "google_compute_subnetwork" "subnet-for-l7lb" {
  provider      = google-beta
  project       = var.project-id
  count         = length(var.regions) == 0 ? 0 : length(var.regions)
  name          = format("subnet-%s-%s", split("-", var.regions[count.index])[0], "${count.index}")
  ip_cidr_range = var.ip-cidrs[count.index]
  region        = var.regions[count.index]
  purpose       = "PRIVATE"
  role          = "ACTIVE"
  network       = google_compute_network.vpc-network[0].id
}