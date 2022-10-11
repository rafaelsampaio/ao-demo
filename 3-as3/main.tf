#Main
#Terraform Version Pinning
terraform {
  required_version = "~> 1.2"
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "~> 1.15.2"
    }
  }
}

#F5 BIG-IP Provider
provider "bigip" {
  address  = var.bigip-address
  username = var.bigip-admin
  password = var.bigip-passwd
}
