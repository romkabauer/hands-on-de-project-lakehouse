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
