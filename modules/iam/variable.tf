variable "service_account_id" {
  type        = string
  description = "service account unique id"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "service_account_display_name" {
  type        = string
  description = "Generic Display Name for the Service Account"
  default     = "Generic Service Account"
}

variable "role_list" {
  type        = list(string)
  description = "IAM service Account binding with roles"
  default = [
    "roles/cloudkms.cryptoKeyDecrypter",
    "roles/storage.admin"
  ]
}