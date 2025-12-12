resource "google_project_iam_member" "admin_os_admin_login" {
  project = var.project_id
  role    = "roles/compute.osAdminLogin"
  member  = "user:${var.admin_user_email}"
}

resource "google_project_iam_member" "admin_iap_tunnel" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "user:${var.admin_user_email}"
}

resource "google_project_iam_member" "admin_compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "user:${var.admin_user_email}"
}

resource "google_project_iam_member" "admin_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "user:${var.admin_user_email}"
}

resource "google_project_iam_member" "admin_kms_admin" {
  project = var.project_id
  role    = "roles/cloudkms.admin"
  member  = "user:${var.admin_user_email}"
}

resource "google_project_iam_member" "admin_kms_encrypter_decrypter" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "user:${var.admin_user_email}"
}

resource "google_service_account" "github_actions" {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
  description  = "Service Account para CI/CD con GitHub Actions"
}

resource "google_project_iam_member" "github_actions_os_login" {
  project = var.project_id
  role    = "roles/compute.osLogin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_iap_tunnel" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_kms_viewer" {
  project = var.project_id
  role    = "roles/cloudkms.viewer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_kms_encrypter_decrypter" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}