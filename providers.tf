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
  }
}


provider "digitalocean" {
    token = var.digitalocean_token
}



provider "http" {
  # Configuration options
}


