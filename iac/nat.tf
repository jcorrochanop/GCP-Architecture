resource "google_compute_router" "router_pro" {
  name    = "router-pro"
  region  = var.region
  network = google_compute_network.vpc_pro.id

  description = "Cloud Router para VPC PRO"
}

resource "google_compute_router_nat" "nat_pro" {
  name   = "cloud-nat-pro"
  router = google_compute_router.router_pro.name
  region = google_compute_router.router_pro.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_router" "router_dev" {
  name    = "router-dev"
  region  = var.region
  network = google_compute_network.vpc_dev.id

  description = "Cloud Router para VPC DEV"
}

resource "google_compute_router_nat" "nat_dev" {
  name   = "cloud-nat-dev"
  router = google_compute_router.router_dev.name
  region = google_compute_router.router_dev.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
