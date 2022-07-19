#General
#Google Environment
variable "prefix" {}
variable "gcp-region" {}

#BIG-IP
variable "bigip-address" {}
variable "bigip-admin" { default = "admin" }
variable "bigip-passwd" {}

#App
variable "app-tenant" { default = "AO-DEMO" }
variable "app-name" { default = "AO-DEMO-APP" }
variable "app-address" {}
variable "app-node-port" { default = "8000" }
variable "app-node-ip" {}
