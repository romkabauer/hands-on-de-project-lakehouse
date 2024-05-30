output "kafka-service" {
  value = "${kubernetes_service.service_kafka_headless.metadata[0].name}.${var.k8s-namespace}"
}