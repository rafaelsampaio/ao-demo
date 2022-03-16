#Main
#Terraform Version Pinning
terraform {
  required_version = "~> 1.1.0"
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "~> 1.13"
    }
  }
}

#F5 BIG-IP Provider
provider "bigip" {
  address  = var.bigip-address
  username = var.bigip-admin
  password = var.bigip-passwd
}
