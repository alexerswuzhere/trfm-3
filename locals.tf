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
