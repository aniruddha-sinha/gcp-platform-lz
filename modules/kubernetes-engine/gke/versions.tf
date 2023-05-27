terraform {
  required_version = ">= 1.4.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.60.0" # tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.60.0" # tftest
    }
  }
}


