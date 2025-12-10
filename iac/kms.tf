resource "google_kms_key_ring" "vm_keyring" {
  name     = var.kms_keyring_name
  location = var.region
}

resource "google_kms_crypto_key" "vm_disk_key" {
  name     = var.kms_key_name
  key_ring = google_kms_key_ring.vm_keyring.id

  rotation_period = var.kms_rotation_period

  lifecycle {
    prevent_destroy = false
  }

  purpose = "ENCRYPT_DECRYPT"

  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
  }
}

data "google_project" "project" {
  project_id = var.project_id  
}

resource "google_kms_crypto_key_iam_member" "compute_engine_encrypter_decrypter" {
  crypto_key_id = google_kms_crypto_key.vm_disk_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
}
