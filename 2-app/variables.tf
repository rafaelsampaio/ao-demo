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
variable "server-machine" { default = "e2-medium" }
variable "server-image" { default = "projects/f5-gcs-4261-sales-sa-all/global/machineImages/rsampaio-server-containers" }
variable "server-network" {}
variable "server-subnetwork" {}

#Tags
variable "tag-environment" { default = "ao-demo" }
variable "tag-owner" { default = "ao-demo" }
variable "tag-group" { default = "ao-demo" }
