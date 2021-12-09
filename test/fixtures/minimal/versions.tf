terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.13"
}