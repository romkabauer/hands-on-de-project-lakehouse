resource "kubernetes_namespace" "lakehouse" {
  metadata {
    name = var.k8s-namespace
  }
}

resource "helm_release" "nessie" {
    name = "nessie"
    namespace = kubernetes_namespace.lakehouse.metadata[0].name
    repository = "https://charts.projectnessie.org"
    chart = "nessie"
    version = "0.101.3"
}

resource "helm_release" "trino" {
  name = "trino"
  namespace = kubernetes_namespace.lakehouse.metadata[0].name
  repository = "https://trinodb.github.io/charts"
  chart = "trino"
  version = "1.36.0"

  values = [templatefile("modules/lakehouse/trino_values.yaml", {
      nessie_uri = "http://${helm_release.nessie.metadata[0].name}.${kubernetes_namespace.lakehouse.metadata[0].name}:19120/api/v2"
      warehouse_dir = "gs://expenses-warehouse"
    })]
}