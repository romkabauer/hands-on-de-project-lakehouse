variable "k8s-namespace" {
  type = string
  default = "flink"
}

variable "app-name" {
  type        = string
  description = "Name for the beam app"
  default     = "beam-app"
}

variable "kafka-service-name" {}
variable "kafka-input-topic" {}

variable "registry-secret" {sensitive = true}
variable "beam-python-harness-docker-image" {}
