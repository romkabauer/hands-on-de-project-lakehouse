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

data "template_file" "airflow_values" {
  template = <<EOF
executor: "KubernetesExecutor"
createUserJob:
  useHelmHooks: false
  applyCustomEnv: false
migrateDatabaseJob:
  useHelmHooks: false
  applyCustomEnv: false
registry:
  secretName: ${var.registry-secret.metadata[0].name}
defaultAirflowRepository: ${var.default-airflow-repository}
defaultAirflowTag: ${var.airflow-image-tag}
images:
  airflow:
    repository: ${var.default-airflow-repository}
    tag: ${var.airflow-image-tag}
    pullPolicy: Always
webserverSecretKey: ${random_password.airflow-webserver-secret.result}
webserver:
  startupProbe:
    timeoutSeconds: 60
  livenessProbe:
    initialDelaySeconds: 60
env:
  - name: PRODUCER_BATCH_IMAGE
    value: ${var.producer-image}:${var.data-services-image-tag}
  - name: PRODUCER_BATCH_NAMESPACE
    value: ${kubernetes_namespace.airflow.metadata[0].name}
  - name: PRODUCER_BATCH_CONFIG
    value: ${kubernetes_config_map.producer-config.metadata[0].name}
  - name: GCP_CREDS_SECRET_NAME
    value: ${kubernetes_secret.gcp-creds.metadata[0].name}
  - name: GCP_REGISTRY_SECRET
    value: ${var.registry-secret.metadata[0].name}

EOF
}
