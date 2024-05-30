# TODO: Schema Registry

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = var.k8s-namespace
  }
}

resource "kubernetes_service_account" "serviceaccount_kafka" {
    metadata {
      name = var.app-name
      namespace = var.k8s-namespace
    }
}

resource "kubernetes_service" "service_kafka_headless" {
  metadata {
    name = "kafka-headless"
    namespace = var.k8s-namespace
    labels = {
      app = var.app-name
    }
  }

  spec {
    type = "ClusterIP"
    cluster_ip = "None"
    ip_families = ["IPv4"]
    ip_family_policy = "SingleStack"

    selector = {
      app = var.app-name
    }

    port {
      name       = "tcp-client"
      port       = 9092
      protocol   = "TCP"
      target_port = "tcp-client"
    }

    port {
      name       = "tcp-controller"
      port       = 9093
      protocol   = "TCP"
      target_port = "tcp-controller"
    }
  }
}

resource "kubernetes_stateful_set" "statefulset_kafka" {
  metadata {
    labels = {
      app = var.app-name
    }
    name = var.app-name
    namespace = var.k8s-namespace
  }
  spec {
    pod_management_policy = "Parallel"
    replicas = var.brokers-number
    revision_history_limit = 6

    selector {
      match_labels = {
        app = var.app-name
      }
    }

    service_name = "kafka-headless"

    template {
      metadata {
        labels = {
          app = var.app-name
        }
      }

      spec {
        service_account_name = var.app-name

        # Uncomment if there is a need to mount particular volume defined in volume.tf
        # Tested only with one-node kafka instance

        # security_context {
        #   fs_group = 2000
        # }

        # init_container {
        #   name = "permissions"
        #   image = "busybox"
        #   command = ["sh", "-c"]
        #   args = ["chown -R root:2000 /bitnami/kafka/data", "chown -R root:2000 /opt"]
        #   volume_mount {
        #     mount_path = "/bitnami/kafka/data"
        #     name = "kafka-logs"
        #   }
        # }

        container {
          name = var.app-name
          image = var.docker-image
          image_pull_policy = "IfNotPresent"

          # Uncomment if there is a need to mount particular volume defined in volume.tf
          # Tested only with one-node kafka instance

          # security_context {
          #   run_as_user = 0
          #   run_as_group = 2000
          # }

          volume_mount {
            name = "kafka-logs"
            mount_path = "/bitnami/kafka/data"
          }

          env_from {
            config_map_ref {
              name = "kafka-statefulset-config"
            }
          }

          command = [
            "sh",
            "-exc",
            <<-EOT
            export KAFKA_CFG_NODE_ID=$${HOSTNAME##*-}
            
            /opt/bitnami/scripts/kafka/setup.sh
            /entrypoint.sh
            exec /run.sh
            
            EOT
            ,
            ""
          ]

          port {
            container_port = 9092
            name           = "tcp-client"
            protocol       = "TCP"
          }

          port {
            container_port = 9093
            name           = "tcp-controller"
            protocol       = "TCP"
          }

          termination_message_path = "dev/termination-log"
          termination_message_policy = "File"
        }

        restart_policy = "Always"
      }
    }

    volume_claim_template {
      metadata {
        name = "kafka-logs"
        namespace = var.k8s-namespace
      }

      spec {
        access_modes = ["ReadWriteMany"]
        # Uncomment if there is a need to mount some particular volume defined in volume.tf
        # Tested only with one-node kafka instance

        # volume_name = kubernetes_persistent_volume.kafka-volume.metadata[0].name

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    update_strategy {
      type = "RollingUpdate"
    }
  }
}
