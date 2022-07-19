#General
#Google Environment
variable "prefix" {}
variable "gcp-project" {}
variable "gcp-region" {}
variable "gcp-zone" {}

#App
variable "app-target-instance" {}
variable "app-target-network" {}

#Server
variable "server-machine" {}
variable "server-image" {}
variable "server-network" {}
variable "server-subnetwork" {}

#Tags
variable "tag-environment" { default = "ao-demo" }
variable "tag-owner" { default = "ao-demo" }
variable "tag-group" { default = "ao-demo" }
