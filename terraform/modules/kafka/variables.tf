variable "k8s-namespace" {
  type = string
  default = "kafka"
}
variable "brokers-number" {
  description = "Number of kafka brokers to deploy"
  type = number
  default = 3
}

variable "docker-image" {
  type        = string
  description = "Kafka docker image"
  default     = "bitnami/kafka:3.6.1"
}

variable "app-name" {
  type        = string
  description = "Name for the kafka app"
  default     = "kafka"
}

variable "storage-sa-key" {}