resource "kubernetes_secret" "gcp-creds" {
  metadata {
    name = "gcp-creds"
    namespace = var.k8s-namespace
  }

  type = "Opaque"

  data = {
    "gcp_creds.json" = base64decode(var.storage-sa-key)
  }
}

resource "kubernetes_secret" "registry" {
  metadata {
    name = "registry"
    namespace = var.k8s-namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = var.registry-secret.data
}