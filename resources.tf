data "digitalocean_ssh_keys" "keys" {
    filter {
      key = "name"
      values = ["REBRAIN.SSH.PUB.KEY"]
    }
}


resource "digitalocean_ssh_key" "my_tf_key" {
  depends_on = [local_file.ssh_public_file]
   name = "alexerswuzhere_at_gmail_com"
   public_key = file("${local_file.ssh_public_file.filename}")
}


resource "digitalocean_droplet" "droplet_to_task" {
  name = var.droplet_name
  region = var.region
  image = "ubuntu-23-10-x64"
  size = var.droplet_size
  tags = ["devops","alexerswuzhere_at_gmail_com"]
  ssh_keys = [data.digitalocean_ssh_keys.keys.ssh_keys[0].id, digitalocean_ssh_key.my_tf_key.id]
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

