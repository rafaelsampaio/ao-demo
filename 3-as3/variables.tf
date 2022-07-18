#BIG-IP
variable "bigip-address" {}
variable "bigip-admin" { value = "admin" }
variable "bigip-passwd" {}

#App
variable "app-tenant" {}
variable "app-name" {}
variable "app-tag" {}
variable "app-address" {}
variable "app-region" {}
variable "app-node-port" {}
variable "app-node-ip" {}
