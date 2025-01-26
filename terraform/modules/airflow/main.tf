resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.k8s-namespace
  }
}

resource "helm_release" "airflow" {
    name = "airflow"
    namespace = var.k8s-namespace
    repository = "https://airflow.apache.org/"
    chart = "airflow"
    version = "1.15.0"

    values = [
      templatefile(
        "modules/airflow/airflow_values.yaml",
        {
          namespace                       = var.k8s-namespace
          gcp-registry-secret             = var.registry-secret.metadata[0].name
          gcs-creds-secret                = kubernetes_secret.gcp-creds.metadata[0].name

          default-airflow-repository      = var.default-airflow-repository
          airflow-image-tag               = var.airflow-image-tag
          airflow-webserver-secret-result = random_password.airflow-webserver-secret.result

          producer-image                  = var.producer-image
          producer-image-tag              = var.producer-image-tag
          producer-batch-config           = kubernetes_config_map.producer-config.metadata[0].name

          etl-config                      = kubernetes_config_map.etl-config.metadata[0].name
          etl-image                       = var.dbt-trino-pkg-image-name
          etl-image-tag                   = var.dbt-trino-pkg-image-tag

          income-ingestion-bucket-name    = var.income-ingestion-bucket-name
          trino-host                      = var.trino-host
          trino-port                      = var.trino-port
          trino-user                      = var.trino-user
          trino-ing-target-table          = "trino_db.raw.income_batch"
        }
      )
    ]
}
