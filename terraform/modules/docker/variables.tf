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
  default = "2.10.4-0.1.0"
}

variable "data-producer-docker-file-location" {
  type = string
  default = "../transactional_app/."
}

variable "data-producer-image-name" {
  type = string
  default = "data-producer"
}

variable "data-producer-image-tag" {
  type = string
  default = "0.1.0"
}

variable "kafka-connect-docker-file-location" {
  type = string
  default = "../kafka_connect/."
}

variable "kafka-connect-image-name" {
  type = string
  default = "kafka-connect-iceberg"
}

variable "kafka-connect-image-tag" {
  type = string
  default = "7.8.0"
}

# variable "beam-python-harness-docker-file-location" {
#   type = string
#   default = "../beam_consumer"
# }

# variable "beam-python-harness-docker-file-name" {
#   type = string
#   default = "Dockerfile-python-harness"
# }

# variable "beam-python-harness-image-name" {
#   type = string
#   default = "beam-python-harness"
# }

# variable "beam-python-harness-image-tag" {
#   type = string
#   default = "2.61.0_v0.1.0"
# }

variable "dbt-trino-pkg-docker-file-location" {
  type = string
  default = "../dbt_trino/."
}

variable "dbt-trino-pkg-image-name" {
  type = string
  default = "dbt-trino-pkg"
}

variable "dbt-trino-pkg-image-tag" {
  type = string
  default = "1.9.0-0.1.0"
}
