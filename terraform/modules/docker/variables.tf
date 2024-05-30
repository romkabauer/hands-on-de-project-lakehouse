variable "gcp-project-id" {
  description = "Project ID from GCP"
  type = string
}

variable "registry-location" {}
variable "registry-access-key" {sensitive = true}

variable "airflow-repository-id" {}
variable "data-services-repository-id" {}

variable "airflow-docker-file-location" {
  type = string
  default = "../airflow_dags/."
}

variable "airflow-image-name" {
  type = string
  default = "airflow-dags"
}

variable "airflow-image-tag" {
  type = string
  default = "0.1.0"
}

variable "data-services-docker-file-location" {
  type = string
  default = "../transactional_app/."
}

variable "data-services-image-name" {
  type = string
  default = "data-producer"
}

variable "data-services-image-tag" {
  type = string
  default = "0.1.0"
}
