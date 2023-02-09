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
variable "server_machine" { default = "e2-medium" }
variable "server_image" { default = "projects/cos-cloud/global/images/cos-101-17162-127-5" }

#BIG-IP
variable "bigip_name" { default = "bigip" }
variable "bigip_passwd" { sensitive = true }
variable "bigip_machine" { default = "n2-standard-8" }
variable "bigip_image" { default = "projects/f5-7626-networks-public/global/images/f5-bigip-16-1-3-3-0-0-3-payg-best-plus-25mbps-221222234728" }
variable "bigip_timezone" { default = "UTC" }
variable "bigip_mgmt_self" { default = "10.1.1.245" }
variable "bigip_external_self" { default = "10.1.10.245" }
variable "bigip_internal_self" { default = "10.1.20.245" }

#Logstash
variable "logstash-ts-host" {}

#ElasticSearch
variable "es-host" {}
variable "es-username" {}
variable "es-password" {}

#Tags
variable "tag_environment" {}
variable "tag_owner" {}
variable "tag_group" {}
