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
  depends_on = [local_sensitive_file.pem_file]
  count = length(var.devs)
  name = var.devs[count.index].prefix
  region = var.region
  image = "ubuntu-23-10-x64"
  size = var.droplet_size
  tags = [var.tag1,var.tag2]
  ssh_keys = [local.key_id, digitalocean_ssh_key.my_tf_key.id]

  connection {
    type     = "ssh"
    user     = "root"
    host     = self.ipv4_address
    private_key   = file(local_sensitive_file.pem_file.filename)
  }


  provisioner "remote-exec" {
    inline = [
      "echo root:${random_password.random[count.index].result} | chpasswd"
    ]
  }
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



data "aws_route53_zone" "selected" {
  name = "devops.rebrain.srwx.net"
}



resource "aws_route53_record" "www" {
  count = length(var.devs)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.devs[count.index].login}-${var.devs[count.index].prefix}"
  type    = "A"
  ttl     = 300
  records = [local.list_of_ips[count.index]]
}



resource "random_password" "random" {
  count = length(var.devs)
  length           = 16
  special = false
}



# locals {
#   final_list = yamlencode({for i in var.devs: index(var.devs,i) + 1 => "${aws_route53_record.www[index(var.devs,i)].name}.devops.rebrain.srwx.net ${digitalocean_droplet.droplet_to_task[index(var.devs,i)].ipv4_address} ${random_password.random[index(var.devs,i)].result}"})
# }



# resource "local_file" "foo" {
#   content  = local.final_list
#   filename = "${path.module}/final.txt"
# }

resource "local_file" "foo" {
  content  = templatefile("final_file.tftpl",{devs = var.devs[*],fqdn = aws_route53_record.www[*],ip = digitalocean_droplet.droplet_to_task[*],passwords = random_password.random[*]})
  filename = "${path.module}/final.txt"
}