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
