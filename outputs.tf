output "dns_and_ip" {
  value = zipmap(aws_route53_record.www[*].name, digitalocean_droplet.droplet_to_task[*].ipv4_address)
}

