resource "google_artifact_registry_repository" "airflow" {
  project       = var.gcp-project-id
  location      = var.location
  repository_id = "airflow"
  description   = "Airflow DAG containers repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

resource "google_artifact_registry_repository" "data-services" {
  project       = var.gcp-project-id
  location      = var.location
  repository_id = "data-services"
  description   = "Containers for data services"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

resource "google_service_account" "registry-sa" {
    project = var.gcp-project-id
    account_id = "registry-sa-contributor"
    display_name = "Artifact Registry Contributor"
}

resource "google_project_iam_member" "registry-sa-reader" {
  project = var.gcp-project-id
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.registry-sa.email}"
}

resource "google_project_iam_member" "registry-sa-writer" {
  project = var.gcp-project-id
  role = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.registry-sa.email}"
}

resource "google_service_account_key" "registry-sa-key" {
  service_account_id = google_service_account.registry-sa.id
}

resource "kubernetes_secret" "registry" {
  metadata {
    name = "registry"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "us-central1-docker.pkg.dev" = {
          "username" = "_json_key_base64"
          "password" = "${google_service_account_key.registry-sa-key.private_key}"
          "email"    = "${google_service_account.registry-sa.email}"
          "auth"     = base64encode("_json_key_base64:${google_service_account_key.registry-sa-key.private_key}")
        }
      }
    })
  }
}
