variable "k8s-namespace" {
  type = string
  default = "ingestion-layer"
}

variable "app-name" {
  type        = string
  description = "Name for the application"
  default     = "expense-producer"
}

variable "kafka-service-name" {}
variable "registry-secret" {sensitive = true}
variable "docker-image" {}