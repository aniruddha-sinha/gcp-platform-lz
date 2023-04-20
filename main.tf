module "vpc" {
  source = "github.com/aniruddha-sinha/gcp-network-module.git?ref=master"
  //source = "../../modules/vpc"

  project-id               = "odin-twenty"
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}