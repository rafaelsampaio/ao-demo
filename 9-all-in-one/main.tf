#Main
#Terraform Version Pinning
terraform {
  # required_version = "~> 1.5.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      # version = "~> 4.77.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      # version = "~> 4.77.0"
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
  url = "https://text.ipv4.wtfismyip.com/"

  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  general_labels = {
    owner       = "${var.prefix}-${var.tag_owner}"
    environment = "${var.prefix}-${var.tag_environment}"
    group       = "${var.prefix}-${var.tag_group}"
    provider    = "${var.prefix}-terraform"
  }
}

data "template_file" "startup_script" {
  template = file("${path.module}/app-startup-script.sh")
}
