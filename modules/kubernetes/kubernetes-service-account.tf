#create a service account and its relevant secret
resource "kubernetes_secret" "k8s_secret" {
  count = length(var.kubernetes_service_account_list)
  metadata {
    name      = var.kubernetes_service_account_list[count.index].name
    namespace = var.kubernetes_service_account_list[count.index].namespace
  }
}


resource "kubernetes_service_account" "odin_service_account" {
  depends_on = [kubernetes_secret.k8s_secret]
  count      = length(var.kubernetes_service_account_list)
  metadata {
    name      = var.kubernetes_service_account_list[count.index].name
    namespace = var.kubernetes_service_account_list[count.index].namespace
  }
  
  secret {
    name = kubernetes_secret.k8s_secret[count.index].metadata.0.name
  }
}

