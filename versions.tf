terraform {
  cloud {
    organization = "asinha0493"
    workspaces {
      name = "gcp-platform-lz"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}