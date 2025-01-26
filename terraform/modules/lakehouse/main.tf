resource "kubernetes_namespace" "lakehouse" {
  metadata {
    name = var.k8s-namespace
  }
}

resource "helm_release" "nessie" {
    name = "nessie"
    namespace = var.k8s-namespace
    repository = "https://charts.projectnessie.org"
    chart = "nessie"
    version = "0.101.3"

    values = [templatefile("modules/lakehouse/nessie_values.yaml", {
      base_warehouse_path = "gs://${var.expenses-warehouse-bucket-name}"
    })]
}

resource "helm_release" "trino" {
  name = "trino"
  namespace = var.k8s-namespace
  repository = "https://trinodb.github.io/charts"
  chart = "trino"
  version = "1.36.0"

  values = [templatefile("modules/lakehouse/trino_values.yaml", {
      nessie_uri = "http://${helm_release.nessie.metadata[0].name}.${kubernetes_namespace.lakehouse.metadata[0].name}:19120/api/v2",
      base_warehouse_path = "gs://${var.expenses-warehouse-bucket-name}"
    })]
}
