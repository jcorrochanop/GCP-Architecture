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
    kms_key_self_link = data.google_kms_crypto_key.vm_disk_key.id
  }

  network_interface {
    network    = google_compute_network.vpc_pro.id
    subnetwork = google_compute_subnetwork.subnets_pro[0].id
  }

  # Habilitar OS Login
  metadata = {
    enable-oslogin = "TRUE"
    startup-script = templatefile("${path.module}/../scripts/install-datadog-agent.sh", 
    {
      DATADOG_API_KEY = var.datadog_api_key
      DATADOG_SITE    = var.datadog_site
      VM_ENV          = "production"
      VM_VPC          = "pro"
    })
  }

  # Labels para identificar en GCP
  labels = {
    environment = "production"
    vpc         = "pro"
    monitored   = "datadog"
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

    kms_key_self_link = data.google_kms_crypto_key.vm_disk_key.id
  }

  network_interface {
    network    = google_compute_network.vpc_dev.id
    subnetwork = google_compute_subnetwork.subnets_dev[0].id
  }

  metadata = {
    enable-oslogin = "TRUE"
    startup-script = templatefile("${path.module}/../scripts/install-datadog-agent.sh", 
    {
      DATADOG_API_KEY = var.datadog_api_key
      DATADOG_SITE    = var.datadog_site
      VM_ENV          = "development"
      VM_VPC          = "dev"
    })
  }
  
  labels = {
    environment = "development"
    vpc         = "dev"
    monitored   = "datadog"
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
