resource "kubernetes_config_map" "kafka-statefulset-config" {
  metadata {
    name      = "kafka-statefulset-config"
    namespace = var.k8s-namespace
  }

  data = {
    KAFKA_CFG_PROCESS_ROLES                     = "controller,broker"
    KAFKA_CFG_CONTROLLER_LISTENER_NAMES         = "CONTROLLER"
    KAFKA_CFG_INTER_BROKER_LISTENER_NAME        = "CLIENT"
    KAFKA_CFG_LISTENERS                         = "CLIENT://:9092,CONTROLLER://:9093"
    KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP    = "CLIENT:PLAINTEXT,CONTROLLER:PLAINTEXT"
    KAFKA_ADVERTISED_LISTENERS                  = "CLIENT://${kubernetes_service.service_kafka_headless.metadata[0].name}.${var.k8s-namespace}:9092"
    KAFKA_KRAFT_CLUSTER_ID                      = "kafka-kraft-cluster-00"
    KAFKA_CFG_CONTROLLER_QUORUM_VOTERS          = join(",", [
      for broker in range(0,var.brokers-number):
        "${broker}@${var.app-name}-${broker}.${kubernetes_service.service_kafka_headless.metadata[0].name}.${var.k8s-namespace}:9093"
    ])
  }
}

# One node kafka deployment config

# resource "kubernetes_config_map" "kafka-config" {
#   metadata {
#     name      = "kafka-deployment-config"
#     namespace = var.k8s-namespace
#   }

#   depends_on = [
#     var.k8s-namespace
#   ]

#   data = {
#     KAFKA_CFG_NODE_ID                           = 0
#     KAFKA_CFG_PROCESS_ROLES                     = "controller,broker"
#     KAFKA_CFG_CONTROLLER_LISTENER_NAMES         = "CONTROLLER"
#     KAFKA_CFG_INTER_BROKER_LISTENER_NAME        = "CLIENT"
#     KAFKA_CFG_LISTENERS                         = "CLIENT://:9092,CONTROLLER://:9093"
#     KAFKA_ADVERTISED_LISTENERS                  = "CLIENT://${var.kafka-app-name}.${var.k8s-namespace}:9092"
#     KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP    = "CONTROLLER:PLAINTEXT,CLIENT:PLAINTEXT"
#     KAFKA_CFG_CONTROLLER_QUORUM_VOTERS          = "0@localhost:9093"
#   }
# }
