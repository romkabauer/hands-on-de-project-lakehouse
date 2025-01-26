output "storage-access-key" {
  value = google_service_account_key.sa-storage-key.private_key
  sensitive = true
}

output "income-ingestion-bucket-name" {
  value = var.income-ingestion-bucket-name
}

output "expenses-warehouse-bucket-name" {
  value = var.expenses-warehouse-bucket-name
}