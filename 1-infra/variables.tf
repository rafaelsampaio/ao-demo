#General
#Google Environment
variable "prefix" {}
variable "gcp-project" {}
variable "gcp-region" {}
variable "gcp-zone" {}
variable "gcp-svc-acct" {}

#Network
variable "mgmt-cidr" { default = "10.1.1.0/24" }
variable "external-cidr" { default = "10.1.10.0/24" }
variable "internal-cidr" { default = "10.1.20.0/24" }

#BIG-IP
variable "bigip-name" { default = "bigip" }
variable "bigip-passwd" { sensitive = true }
variable "bigip-machine" { default = "n2-standard-8" }
variable "bigip-image" { default = "projects/f5-7626-networks-public/global/images/f5-bigip-16-1-3-1-0-0-11-payg-best-plus-25mbps-220721054250" }
variable "bigip-timezone" { default = "UTC" }
variable "bigip-mgmt-self" { default = "10.1.1.245" }
variable "bigip-external-self" { default = "10.1.10.245" }
variable "bigip-internal-self" { default = "10.1.20.245" }

#Tags
variable "tag-environment" { default = "ao-demo" }
variable "tag-owner" { default = "ao-demo" }
variable "tag-group" { default = "ao-demo" }
