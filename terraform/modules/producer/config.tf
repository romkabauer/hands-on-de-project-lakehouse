resource "kubernetes_config_map" "producer-config" {
  metadata {
    name      = "producer-config"
    namespace = var.k8s-namespace
  }

  data = {
    APPLICATION_TYPE                    = "PRODUCER"

    PRODUCER_TYPE                       = "EVENT"
    PRODUCER_EVENT_FREQUENCY            = 3
    EVENT_GENERATOR_FORMAT              = "JSON"
    EVENT_GENERATOR_DEFAULT_MESSAGE     = "Event body with information"

    KAFKA_SERVER                        = "${var.kafka-service-name}:9092"
    KAFKA_TOPIC_NAME                    = "expenses"
  }
}