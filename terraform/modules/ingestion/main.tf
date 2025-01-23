resource "kubernetes_namespace" "ingestion" {
  metadata {
    name = var.k8s-namespace
  }
}

resource "helm_release" "kafka_connect" {
    name = "kafka-connect"
    namespace = var.k8s-namespace
    repository = "https://confluentinc.github.io/cp-helm-charts/"
    chart = "cp-helm-charts"

    values = [templatefile("modules/ingestion/kafka_connect_values.yaml", {
      namespace = var.k8s-namespace,
      kafka_service_name = "${var.kafka-service-name}:9092",
      kafka_connect_image_name = var.kafka_connect_image_name,
      kafka_connect_image_tag = var.kafka_connect_image_tag,
      registry_secret = kubernetes_secret.registry.metadata[0].name
    })]
}
