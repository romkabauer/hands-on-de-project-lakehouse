variable "gcp-project-id" {
  description = "Project ID from GCP"
  type = string
}

variable "registry-secret" {sensitive = true}

variable "default-airflow-repository" {}
variable "producer-image" {}
variable "airflow-image-tag" {type = string}
variable "data-services-image-tag" {type = string}

variable "storage-sa-key" {}
variable "storage-bucket-name" {}
