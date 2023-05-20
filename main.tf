module "vpc" {
  source = "./modules/gcp-network-module"

  project-id               = var.project_id
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}