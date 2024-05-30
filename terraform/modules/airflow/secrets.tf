resource "kubernetes_secret" "gcp-creds" {
  metadata {
    name = "gcp-creds"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  type = "Opaque"

  data = {
    "gcp_creds.json" = base64decode(var.storage-sa-key)
  }
}

resource "random_password" "airflow-webserver-secret" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
