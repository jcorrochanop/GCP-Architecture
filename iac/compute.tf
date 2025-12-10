resource "google_compute_instance" "vm_pro_1" {
  name         = "vm-pro-1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["allow-iap"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }

    # Cifrado con Cloud KMS
    kms_key_self_link = google_kms_crypto_key.vm_disk_key.id
  }

  network_interface {
    network    = google_compute_network.vpc_pro.id
    subnetwork = google_compute_subnetwork.subnets_pro[0].id
  }

  # Habilitar OS Login
  metadata = {
    enable-oslogin = "TRUE"
  }

  # Service Account (usa la default de Compute Engine)
  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  # Dependencia: esperar a que KMS tenga permisos
  depends_on = [
    google_kms_crypto_key_iam_member.compute_engine_encrypter_decrypter
  ]
}

resource "google_compute_instance" "vm_pro_2" {
  name         = "vm-pro-2"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["allow-iap"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }

    kms_key_self_link = google_kms_crypto_key.vm_disk_key.id
  }

  network_interface {
    network    = google_compute_network.vpc_pro.id
    subnetwork = google_compute_subnetwork.subnets_pro[1].id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_kms_crypto_key_iam_member.compute_engine_encrypter_decrypter
  ]
}

resource "google_compute_instance" "vm_dev_1" {
  name         = "vm-dev-1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["allow-iap"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }

    kms_key_self_link = google_kms_crypto_key.vm_disk_key.id
  }

  network_interface {
    network    = google_compute_network.vpc_dev.id
    subnetwork = google_compute_subnetwork.subnets_dev[0].id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_kms_crypto_key_iam_member.compute_engine_encrypter_decrypter
  ]
}

resource "google_compute_instance" "vm_dev_2" {
  name         = "vm-dev-2"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["allow-iap"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }

    kms_key_self_link = google_kms_crypto_key.vm_disk_key.id
  }

  network_interface {
    network    = google_compute_network.vpc_dev.id
    subnetwork = google_compute_subnetwork.subnets_dev[1].id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_kms_crypto_key_iam_member.compute_engine_encrypter_decrypter
  ]
}

data "google_compute_default_service_account" "default" {
  project = var.project_id
}
