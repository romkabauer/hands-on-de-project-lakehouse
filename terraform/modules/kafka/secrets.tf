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