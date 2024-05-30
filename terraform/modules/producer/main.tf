resource "kubernetes_namespace" "ingestion-layer" {
  metadata {
    name = var.k8s-namespace
  }
}

resource "kubernetes_secret" "registry" {
  metadata {
    name = "registry"
    namespace = kubernetes_namespace.ingestion-layer.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = var.registry-secret.data
}

resource "kubernetes_deployment" "producer" {
  metadata {
    name = var.app-name
    namespace = var.k8s-namespace
    labels = {
      app = var.app-name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app-name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app-name
        }
      }

      spec {
        image_pull_secrets {
          name = var.registry-secret.metadata[0].name
        }

        container {
          name  = var.app-name
          image = var.docker-image

          image_pull_policy = "IfNotPresent"

          port {
            container_port = 80
          }

          env_from {
            config_map_ref {
              name = "producer-config"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "producer-service" {
  metadata {
    name = var.app-name
    namespace = var.k8s-namespace
  }

  depends_on = [
    kubernetes_deployment.producer
  ]

  spec {
    selector = {
      app = var.app-name
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}
