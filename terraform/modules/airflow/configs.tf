resource "kubernetes_config_map" "producer-config" {
  metadata {
    name      = "batch-producer-config"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  data = {
    APPLICATION_TYPE                    = "PRODUCER"

    PRODUCER_TYPE                       = "BATCH"

    BATCH_GENERATOR_FORMAT              = "CSV"
    BATCH_SAMPLE_SIZE                   = 20000

    BATCH_WRITER_GCS_BUCKET             = var.storage-bucket-name
  }
}
