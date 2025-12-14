data "google_kms_key_ring" "vm_keyring" {
  name     = "vm-kering-proyecto"
  location = var.region
}

data "google_kms_crypto_key" "vm_disk_key" {
  name     = "vm-disk-key-proyecto"
  key_ring = data.google_kms_key_ring.vm_keyring.id
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_kms_crypto_key_iam_member" "compute_engine_encrypter_decrypter" {
  crypto_key_id = data.google_kms_crypto_key.vm_disk_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
}

