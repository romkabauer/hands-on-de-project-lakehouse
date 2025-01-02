resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

resource "kubernetes_secret" "registry" {
  metadata {
    name = "registry"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = var.registry-secret.data
}

resource "helm_release" "airflow" {
    name = "airflow"
    namespace = kubernetes_namespace.airflow.metadata[0].name
    repository = "https://airflow.apache.org/"
    chart = "airflow"
    version = "1.11.0"

    values = [
      templatefile(
        "modules/airflow/airflow_values.yaml",
        {
          registry-secret-name            = var.registry-secret.metadata[0].name
          default-airflow-repository      = var.default-airflow-repository
          airflow-image-tag               = var.airflow-image-tag
          airflow-webserver-secret-result = random_password.airflow-webserver-secret.result
          producer-image                  = var.producer-image
          data-services-image-tag         = var.data-services-image-tag
          namespace                       = kubernetes_namespace.airflow.metadata[0].name
          producer-batch-config           = kubernetes_config_map.producer-config.metadata[0].name
          gcp-creds-secret                = kubernetes_secret.gcp-creds.metadata[0].name
          gcp-registry-secret             = var.registry-secret.metadata[0].name
        }
      )
    ]
}
