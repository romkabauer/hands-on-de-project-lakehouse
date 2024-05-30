# resource "kubernetes_deployment" "kafka" {
#   metadata {
#     name = var.app-name
#     namespace = var.k8s-namespace.metadata[0].name
#     labels = {
#       app = var.app-name
#     }
#   }

#   depends_on = [
#     kubernetes_namespace.project-namespace
#   ]

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = var.app-name
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = var.app-name
#         }
#       }

#       spec {
#         container {
#           name  = var.app-name
#           image = var.docker-image

#           image_pull_policy = "IfNotPresent"

#           port {
#             container_port = 9092
#           }

#           env_from {
#             config_map_ref {
#               name = "kafka-deployment-config"
#             }
#           }

#           readiness_probe {
#             tcp_socket {
#               port = 9092
#             }

#             initial_delay_seconds = 10
#             timeout_seconds       = 5
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "kafka-service" {
#   metadata {
#     name = var.app-name
#     namespace = var.k8s-namespace.metadata[0].name
#   }

#   depends_on = [
#         kubernetes_deployment.kafka
#   ]

#   spec {
#     selector = {
#       app = var.app-name
#     }

#     port {
#       port        = 9092
#       target_port = 9092
#     }
#   }
# }
