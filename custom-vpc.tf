resource "google_compute_network" "vpc" {
  name                    = "${var.project}-${terraform.workspace}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnets" {
  for_each      = var.regions
  name          = "${var.project}-${terraform.workspace}-subnet-${each.value}"
  ip_cidr_range = var.subnet_cidrs[each.value]
  network       = google_compute_network.vpc.name
  region        = each.value
}
