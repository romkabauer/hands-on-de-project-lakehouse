variable "gcp-project-id" {
  description = "Project ID from GCP"
  type = string
}

variable "sa-storage-key-file-name" {
  description = "File name for service account access key for storage"
  type = string
  default = "sa-storage-key.json"
}

variable "bucket-name" {
  type = string
  default = "expenses-de-project"
}

variable "bucket-location" {
  type = string
  default = "US-CENTRAL1"
}
