resource "kubernetes_config_map" "producer-config" {
  metadata {
    name      = "batch-producer-config"
    namespace = var.k8s-namespace
  }

  data = {
    APPLICATION_TYPE                    = "PRODUCER"

    PRODUCER_TYPE                       = "BATCH"

    BATCH_GENERATOR_FORMAT              = "CSV"

    # TODO: refactor to use TrinoOperator instead of GCSToTrinoOperator
    # GCSToTrinoOperator uses dbapi_hook which executes separate insert statement for each row in csv
    # Try to implement batch insert using TrinoOperator
    # If sample size is too large, it will cause performance issues
    # https://airflow.apache.org/docs/apache-airflow/1.10.15/_modules/airflow/hooks/dbapi_hook.html#DbApiHook.insert_rows
    BATCH_SAMPLE_SIZE                   = 10
    BATCH_INCLUDE_HEADER                = 0

    BATCH_WRITER_GCS_BUCKET             = var.income-ingestion-bucket-name
  }
}

resource "kubernetes_config_map" "etl-config" {
  metadata {
    name      = "etl-config"
    namespace = var.k8s-namespace
  }

  data = {
    TRINO_HOST = "${var.trino-host}"
    TRINO_PORT = "${var.trino-port}"
    TRINO_USER = "${var.trino-user}"
  }
}
