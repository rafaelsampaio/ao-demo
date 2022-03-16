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
variable "tag-environment" {}
variable "tag-owner" {}
variable "tag-group" {}
variable "tag-application" {}
