output "registry-access-key" {
  value = google_service_account_key.registry-sa-key.private_key
  sensitive = true
}

output "registry-sa-email" {
  value = google_service_account.registry-sa.email
  sensitive = true
}

output "airflow-repository-id" {
  value = google_artifact_registry_repository.airflow.repository_id
}

output "data-services-repository-id" {
  value = google_artifact_registry_repository.data-services.repository_id
}

output "registry-location" {
  value = var.location
}

output "registry-secret" {
  value = kubernetes_secret.registry
}
