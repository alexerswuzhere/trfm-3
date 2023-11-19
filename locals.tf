locals {
  list_keys_id = [
    for i in jsondecode(data.http.example.response_body)["ssh_keys"][*] : 
    i.id
    if i.name == "REBRAIN.SSH.PUB.KEY"
  ]
}



locals {
  key_id = local.list_keys_id[0]
}



locals {
  list_of_ips = digitalocean_droplet.droplet_to_task.*.ipv4_address
}



locals {
  ip_dns_map = zipmap(local.list_of_ips, aws_route53_record.www[*].name)
}


