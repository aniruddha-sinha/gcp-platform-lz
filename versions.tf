terraform {
  backend "gcs" {
    bucket = "odin-admin-state-bkt"
    prefix = "gcp-platform-lz/state"
  }


  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.0"
    }
  }
  required_version = ">= 0.13"
}
