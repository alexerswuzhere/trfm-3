output "droplet_public_ipv4" {
  value = digitalocean_droplet.droplet_to_task.ipv4_address
}

output "droplet_domen_name" {
  value = local.final_dns
}