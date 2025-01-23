variable "k8s-namespace" {
  type = string
  default = "ingestion"
}

variable "storage-sa-key" {sensitive = true}
variable "registry-secret" {sensitive = true}

variable "kafka-service-name" {}

variable "kafka_connect_image_name" {}
variable "kafka_connect_image_tag" {}