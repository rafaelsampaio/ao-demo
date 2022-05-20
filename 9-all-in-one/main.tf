#Main
#Terraform Version Pinning
terraform {
  required_version = "~> 1.2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.21"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.21"
    }
  }
}

#Google Provider
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

provider "google-beta" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

#Other
data "http" "myip" {
  url = "https://ifconfig.io/ip"

  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  app_labels = {
    owner       = "${var.prefix}-${var.tag_owner}"
    environment = "${var.prefix}-${var.tag_environment}"
    group       = "${var.prefix}-${var.tag_group}"
    application = "${var.prefix}-${var.tag_application}"
    provider    = "${var.prefix}-terraform"
  }
  general_labels = {
    owner       = "${var.prefix}-${var.tag_owner}"
    environment = "${var.prefix}-${var.tag_environment}"
    group       = "${var.prefix}-${var.tag_group}"
    provider    = "${var.prefix}-terraform"
  }
}
