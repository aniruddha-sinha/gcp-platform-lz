variable "cluster_name" {
  type        = string
  description = "name of the cluster"
}

variable "project_id" {
  type        = string
  description = "gcp project id"
}

variable "location" {
  type        = string
  description = "location in which gcp cluster is going to be placed"
}

variable "network" {
  type        = string
  description = "network in which GKE cluster is going to be created"
}

variable "subnetwork" {
  type        = string
  description = "subnetwork in which the gke cluster is going to be placed"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}

variable "master_auth_config" {
  type = object({
    name    = string,
    ip_addr = string
  })
}

# variable "node_config" {
#   type = object({
#     disk_size_gb    = string
#     disk_type       = string
#     image_type      = string
#     machine_type    = string
#     oauth_scopes    = list(string)
#     preemptible     = bool
#     service_account = string
#     labels          = map(string)
#   })
# }

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools"
}