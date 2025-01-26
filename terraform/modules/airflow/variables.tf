variable "k8s-namespace" {
  type = string
  default = "airflow"
}

variable "gcp-project-id" {
  description = "Project ID from GCP"
  type = string
}

variable "registry-secret" {sensitive = true}

variable "storage-sa-key" {sensitive = true}
variable "income-ingestion-bucket-name" {type = string}

variable "default-airflow-repository" {}
variable "airflow-image-tag" {type = string}

variable "producer-image" {type = string}
variable "producer-image-tag" {type = string}
variable "dbt-trino-pkg-image-name" {type = string}
variable "dbt-trino-pkg-image-tag" {type = string}

variable "trino-host" {type = string}
variable "trino-port" {type = string}
variable "trino-user" {type = string}
