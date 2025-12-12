resource "google_compute_firewall" "allow_iap_ssh_pro" {
  name    = "allow-iap-ssh-pro"
  network = google_compute_network.vpc_pro.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap"]

  description = "Permite SSH vía IAP en VPC PRO"
}

resource "google_compute_firewall" "allow_icmp_pro" {
  name    = "allow-icmp-pro"
  network = google_compute_network.vpc_pro.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]

  description = "Permite ICMP interno en VPC PRO"
}

resource "google_compute_firewall" "allow_internal_pro" {
  name    = "allow-internal-pro"
  network = google_compute_network.vpc_pro.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]

  description = "Permite todo el tráfico interno en VPC PRO"
}

resource "google_compute_firewall" "allow_from_dev_to_pro" {
  name    = "allow-from-dev-to-pro"
  network = google_compute_network.vpc_pro.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.1.0.0/16"]

  description = "Permite tráfico desde VPC DEV a VPC PRO"
}

resource "google_compute_firewall" "allow_iap_ssh_dev" {
  name    = "allow-iap-ssh-dev"
  network = google_compute_network.vpc_dev.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap"]

  description = "Permite SSH vía IAP en VPC DEV"
}

resource "google_compute_firewall" "allow_icmp_dev" {
  name    = "allow-icmp-dev"
  network = google_compute_network.vpc_dev.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.1.0.0/16"]

  description = "Permite ICMP interno en VPC DEV"
}

resource "google_compute_firewall" "allow_internal_dev" {
  name    = "allow-internal-dev"
  network = google_compute_network.vpc_dev.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.1.0.0/16"]

  description = "Permite todo el tráfico interno en VPC DEV"
}

resource "google_compute_firewall" "allow_from_pro_to_dev" {
  name    = "allow-from-pro-to-dev"
  network = google_compute_network.vpc_dev.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]

  description = "Permite tráfico desde VPC PRO a VPC DEV"
}
