output "dns_and_ip" {
  value = local.ip_dns_map
}

output "root_passwords" {
  value = [
    for i in random_password.random[*].result :
    nonsensitive(i)
  ]
}
