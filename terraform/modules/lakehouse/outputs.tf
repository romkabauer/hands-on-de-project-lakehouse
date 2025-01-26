output "trino-host" {
  value = "${helm_release.trino.metadata[0].name}.${var.k8s-namespace}"
}

output "trino-port" {
  value = "8095"
}

output "trino-user" {
  value = "trino-user"
}