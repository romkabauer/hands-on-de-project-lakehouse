resource "kubernetes_namespace" "flink" {
  metadata {
    name = "flink"
  }
}

resource "helm_release" "flink" {
    name = "flink"
    namespace = kubernetes_namespace.flink.metadata[0].name
    repository = "https://downloads.apache.org/flink/flink-kubernetes-operator-1.8.0/"
    chart = "flink-kubernetes-operator"
    version = "1.8.0"

    values = [templatefile("modules/flink/flink_values.yaml", {})]

}
