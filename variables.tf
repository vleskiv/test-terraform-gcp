variable "ssh_public_key_filepath" {
  description = "Filepath for the ssh public key"
  type        = "string"
  default = "ubuntu.pub"
}

variable "name" { default = "nexus" }
variable "project" { default = "test1-terraform-gcp" }
variable "instance_type" { default = "n1-standard-1" }
variable "region" { default = "us-west1" }
variable "user" { default = "ubuntu" }
variable "image" { default = "ubuntu-os-cloud/ubuntu-1804-lts" }
variable "network_name" { default = "default" }
variable "env" { default = "test" }
variable "zones" { type = "list" default = ["us-west1-a"]}
variable "count" { default = 2 }