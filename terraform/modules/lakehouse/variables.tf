variable "k8s-namespace" {
  type = string
  default = "lakehouse"
}

variable "gcp-project-id" {
  type = string
}

variable "storage-sa-key" {sensitive = true}
variable "expenses-warehouse-bucket-name" {type = string}