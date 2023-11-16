terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.31.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}


provider "aws" {
  region     = var.aws_region
  acces_token = var.aws_acces_token
  aws_secret_key = var.aws_secret_key
}


provider "digitalocean" {
    token = var.digitalocean_token
}



provider "http" {
  # Configuration options
}


