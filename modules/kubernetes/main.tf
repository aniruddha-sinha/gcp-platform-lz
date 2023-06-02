resource "kubernetes_namespace" "kubernetes_namespace" {
  count = length(var.kubernetes_namespace_list)
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = var.kubernetes_namespace_list[count.index]
  }
}
