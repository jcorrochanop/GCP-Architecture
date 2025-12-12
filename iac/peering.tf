resource "google_compute_network_peering" "peering_pro_to_dev" {
  name         = "peering-pro-to-dev"
  network      = google_compute_network.vpc_pro.id
  peer_network = google_compute_network.vpc_dev.id

  export_custom_routes = false
  import_custom_routes = false
}

resource "google_compute_network_peering" "peering_dev_to_pro" {
  name         = "peering-dev-to-pro"
  network      = google_compute_network.vpc_dev.id
  peer_network = google_compute_network.vpc_pro.id

  export_custom_routes = false
  import_custom_routes = false
  
  depends_on = [google_compute_network_peering.peering_pro_to_dev]
}
