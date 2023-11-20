variable "digitalocean_token" {
  type = string
}

variable "droplet_name" {
  type = string
  default = "droplet-to-task"
}

variable "region" {
  type = string
  default = "AMS3"
}

variable "droplet_size" {
    type = string
    default = "s-1vcpu-1gb"
}

variable "private_ssh_key_directory" {
  description = "input directory to ssh PRIVATE file"
  type = string
}

variable "private_key_pem_name" {
  description = "input name to ssh PRIVATE file"
  type = string
}

variable "public_ssh_key_directory" {
  description = "input directory to ssh PUBLIC file"
  type = string
}

variable "public_ssh_key_name" {
  description = "input name to ssh PUBLIC file"
  type = string
}

variable "digital_ocean_key_name" {
  description = "input your public ssh key name in digital_ocean"
}

variable "tag1" {
  description = "input your first tag to digital_ocean droplet"
  type = string
}

variable "tag2" {
  description = "input your second tag to digital_ocean droplet"
  type = string
}

variable "aws_acces_token" {
  description = "input your aws access token"
  type = string
}

variable "aws_secret_key" {
  description = "input your aws secret key"
  type = string
}

variable "aws_region" {
  description = "input aws_region"
  type = string
  default = "eu-central-1"
}

variable "amount_of_vds" {
  description = "input amount of vds"
  type = string
}

variable "username" {
  description = "input your username to create dns_name to  VMs"
  type = string
}

variable "root_pass" {
  description = "input your root password to VMs"
  type = string
}