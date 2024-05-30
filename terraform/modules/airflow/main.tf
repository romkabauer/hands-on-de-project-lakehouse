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
    
    values = ["${data.template_file.airflow_values.rendered}"]
}
