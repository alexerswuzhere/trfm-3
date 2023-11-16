data "digitalocean_ssh_keys" "keys" {
    filter {
      key = "name"
      values = ["REBRAIN.SSH.PUB.KEY"]
    }
}



resource "digitalocean_ssh_key" "my_tf_key" {
   name = var.digital_ocean_key_name
   public_key = fileexists("${var.public_ssh_key_directory}${var.public_ssh_key_name}.ssh") == true ? file("${var.public_ssh_key_directory}${var.public_ssh_key_name}.ssh") : tls_private_key.my_key.public_key_openssh
}



resource "digitalocean_droplet" "droplet_to_task" {
  name = var.droplet_name
  region = var.region
  image = "ubuntu-23-10-x64"
  size = var.droplet_size
  tags = [var.tag1,var.tag2]
  ssh_keys = [local.key_id, digitalocean_ssh_key.my_tf_key.id]
}



resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}



resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("${var.private_ssh_key_directory}${var.private_key_pem_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.my_key.private_key_pem
}



resource "local_file" "ssh_public_file" {
  depends_on = [tls_private_key.my_key]
  filename = pathexpand("${var.public_ssh_key_directory}${var.public_ssh_key_name}.ssh")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.my_key.public_key_openssh
}

data "http" "example" {
  url = "https://api.digitalocean.com/v2/account/keys?per_page=100&page=1"

  # Optional request headers
  request_headers = {
    Content-Type = "application/json"
    Authorization = "Bearer ${var.digitalocean_token}"
  }
}

resource "aws_route53_zone" "primary" {
  name = "srwx.net"
}


resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "alexersuwzhere.devops.rebrain.srwx.net"
  type    = "A"
  ttl     = 300
  records = [digitalocean_droplet.droplet_to_task.ipv4_address]
}