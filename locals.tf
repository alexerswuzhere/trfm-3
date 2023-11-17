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
  droplet_ip = digitalocean_droplet.droplet_to_task.ipv4_address
}


locals {
  final_dns = "alexerswuzhere.${data.aws_route53_zone.selected.name}"

}