output "storage-access-key" {
  value = google_service_account_key.sa-storage-key.private_key
  sensitive = true
}

output "storage-bucket-name" {
  value = var.bucket-name
}