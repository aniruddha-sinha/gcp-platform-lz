#get the public ip of the instance running this code
data "http" "tf_cloud_ip" {
  url = "http://api.ipify.org"
}

module "vpc" {
  source = "./modules/vpc"

  project-id               = var.project_id
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}

module "iam" {
  source = "./modules/iam"

  project_id                   = var.project_id
  service_account_id           = "gke-node-sa"
  service_account_display_name = "GKE Node Service Account"
  role_list = [
    "roles/editor"
  ]
}

data "google_compute_network" "gke_network" {
  depends_on = [module.vpc, module.iam]
  name       = "vpc-${var.project_id}"
  project    = var.project_id
}

data "google_compute_subnetwork" "gke_subnetwork" {
  depends_on = [module.vpc, module.iam, data.google_compute_network.gke_network]
  name       = "subnet-us-0"
  project    = var.project_id
  region     = "us-central1"
}

data "google_container_engine_versions" "k8s_versions" {
  project  = var.project_id
  provider = google-beta
  location = "us-central1-a"
  #version_prefix = "1.23."
}

data "google_service_account" "custom_service_account" {
  depends_on = [module.vpc, module.iam]
  account_id = "gke-node-sa"
  project    = var.project_id
}

module "atlas" {
  depends_on   = [module.vpc, module.iam, data.google_service_account.custom_service_account]
  source       = "./modules/kubernetes-engine/gke"
  cluster_name = "atlas"
  project_id   = var.project_id
  location     = "us-central1-a"
  network      = data.google_compute_network.gke_network.name
  subnetwork   = data.google_compute_subnetwork.gke_subnetwork.name

  cidr_blocks = [
    {
      name    = "mac"
      ip_addr = "43.251.74.172/32"
    },
    {
      name    = "tf-cloud"
      ip_addr = "${chomp(data.http.tf_cloud_ip.body)}/32"
    }
  ]
  kubernetes_version = data.google_container_engine_versions.k8s_versions.release_channel_default_version["STABLE"]

  node_pools = [
    {
      name               = "pool2-a"
      version            = data.google_container_engine_versions.k8s_versions.release_channel_default_version["STABLE"]
      initial_node_count = 1
      auto_repair        = true
      auto_upgrade       = true
      image_type         = "COS_CONTAINERD"
      machine_type       = "e2-medium"
      disk_type          = "pd-standard"
      disk_size_gb       = "50"
      service_account    = data.google_service_account.custom_service_account.name
      preemptible        = true
    }
  ]
}

# # # Configure kubernetes provider with Oauth2 access token.
# # # https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# # # This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

data "google_container_cluster" "atlas_cluster" {
  project  = var.project_id
  name     = "atlas"
  location = "us-central1-a"
}

provider "kubernetes" {
  host                   = "https://${module.atlas.endpoint}"
  cluster_ca_certificate = base64decode(module.atlas.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

resource "null_resource" "health_check" {

 provisioner "local-exec" {

    command = "/bin/bash gcloud container clusters get-credentials atlas --zone us-central1-a --project odin-twentyone"
  }
}

# module "kube_cluster_internal" {
#   depends_on = [
#     module.atlas,
#   ]

#   source = "./modules/kubernetes"

#   kubernetes_namespace_list = [
#     "foxtrot",
#     "victor",
#     "zulu"
#   ]
# }
