resource "google_compute_network" "vpc_pro" {
  name                    = var.vpc_pro_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "VPC de Producción (10.0.0.0/16)"
}

resource "google_compute_subnetwork" "subnets_pro" {
  count = length(var.vpc_pro_subnets)

  name          = var.vpc_pro_subnets[count.index].name
  ip_cidr_range = var.vpc_pro_subnets[count.index].cidr
  region        = var.vpc_pro_subnets[count.index].region
  network       = google_compute_network.vpc_pro.id

  description = "Subnet ${count.index + 1} de Producción"

  # Habilitar logs de flujo 
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "vpc_dev" {
  name                    = var.vpc_dev_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "VPC de Desarrollo (10.1.0.0/16)"
}

resource "google_compute_subnetwork" "subnets_dev" {
  count = length(var.vpc_dev_subnets)

  name          = var.vpc_dev_subnets[count.index].name
  ip_cidr_range = var.vpc_dev_subnets[count.index].cidr
  region        = var.vpc_dev_subnets[count.index].region
  network       = google_compute_network.vpc_dev.id

  description = "Subnet ${count.index + 1} de Desarrollo"

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
