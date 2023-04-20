# module "vpc" {
#   source = "github.com/aniruddha-sinha/gcp-network-module.git?ref=master"

#   project-id               = var.project_id
#   is-network-created       = false
#   regions                  = ["us-central1"]
#   ip-cidrs                 = ["10.0.130.0/24"]
#   source-tags              = []
#   target-tags              = []
#   enable-advanced-features = true
# }