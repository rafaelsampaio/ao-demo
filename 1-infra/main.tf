#Main
#Terraform Version Pinning
terraform {
  required_version = "~> 1.1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.14"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.14"
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
data "http" "myip" {
  url = "https://text.ipv4.wtfismyip.com"

  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  labels = {
    owner       = "${var.prefix}-${var.tag-owner}"
    environment = "${var.prefix}-${var.tag-environment}"
    group       = "${var.prefix}-${var.tag-group}"
    provider    = "${var.prefix}-terraform"
  }
}
