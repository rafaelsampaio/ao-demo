#General
#Google Environment
variable "prefix" {}
variable "gcp_project" {}
variable "gcp_region" {}
variable "gcp_zone" {}
variable "gcp_svc_acct" {}

#Network
variable "mgmt_cidr" { default = "10.1.1.0/24" }
variable "external_cidr" { default = "10.1.10.0/24" }
variable "internal_cidr" { default = "10.1.20.0/24" }

#Server
variable "server_machine" {}
variable "server_image" {}

#BIG-IP
variable "bigip_name" { default = "bigip" }
variable "bigip_passwd" { sensitive = true }
variable "bigip_machine" {}
variable "bigip_image" {}
variable "bigip_timezone" {}
variable "bigip_mgmt_self" { default = "10.1.1.245" }
variable "bigip_external_self" { default = "10.1.10.245" }
variable "bigip_internal_self" { default = "10.1.20.245" }

#Tags
variable "tag_environment" {}
variable "tag_owner" {}
variable "tag_group" {}
