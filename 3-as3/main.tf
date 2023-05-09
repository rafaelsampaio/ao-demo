#Main
#Terraform Version Pinning
terraform {
  required_version = "~> 1.4"
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "~> 1.17.1"
    }
  }
}

#F5 BIG-IP Provider
provider "bigip" {
  address  = var.bigip-address
  username = var.bigip-admin
  password = var.bigip-passwd
}
