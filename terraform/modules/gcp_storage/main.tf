resource "google_storage_bucket" "gcs-bucket-income-ingestion" {
    project       = var.gcp-project-id
    name          = var.income-ingestion-bucket-name
    location      = var.bucket-location
    storage_class = "STANDARD"
    force_destroy = true

    uniform_bucket_level_access = true
}

resource "google_storage_bucket" "gcs-bucket-warehouse" {
    project       = var.gcp-project-id
    name          = var.expenses-warehouse-bucket-name
    location      = var.bucket-location
    storage_class = "STANDARD"
    force_destroy = true

    uniform_bucket_level_access = true
}

resource "google_service_account" "gcs-sa" {
    project = var.gcp-project-id
    account_id = "gcs-sa-contributor"
    display_name = "GCS Contributor"
}

resource "google_project_iam_member" "gcs-sa" {
  project = var.gcp-project-id
  role = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.gcs-sa.email}"
}

resource "google_service_account_key" "sa-storage-key" {
  service_account_id = google_service_account.gcs-sa.id
}
