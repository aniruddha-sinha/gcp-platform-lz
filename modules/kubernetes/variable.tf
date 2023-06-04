variable "kubernetes_namespace_list" {
  type = list(string)
}

variable "kubernetes_service_account_list" {
  type = list(object(
    {
      name      = string
      namespace = string
    }
  ))
}
