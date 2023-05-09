#Main
#Terraform Version Pinning
terraform {
  required_version = "~> 1.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.64.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.64.0"
    }
  }
}

#Google Provider
provider "google" {
  project = var.gcp-project
  region  = var.gcp-region
  zone    = var.gcp-zone
}
provider "google-beta" {
  project = var.gcp-project
  region  = var.gcp-region
  zone    = var.gcp-zone
}

#Other
locals {
  labels = {
    owner       = "${var.prefix}-${var.tag-owner}"
    environment = "${var.prefix}-${var.tag-environment}"
    group       = "${var.prefix}-${var.tag-group}"
    application = "${var.prefix}-app"
    provider    = "${var.prefix}-terraform"
  }
}

