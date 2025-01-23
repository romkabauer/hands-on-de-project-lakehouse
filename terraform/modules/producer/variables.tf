variable "k8s-namespace" {
  type = string
  default = "producer"
}

variable "app-name" {
  type        = string
  description = "Name for the application"
  default     = "expense-producer"
}

variable "kafka-service-name" {}
variable "kafka-input-topic" {}
variable "registry-secret" {sensitive = true}
variable "docker-image" {}