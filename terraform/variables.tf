variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "gcp-project-id" {
  description = "Project ID from GCP"
  type = string
  default = "driven-copilot-412019"
}

variable "kafka-expenses-topic" {
  type = string
  default = "expenses"
}
