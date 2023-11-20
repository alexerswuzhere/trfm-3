output "dns_and_ip" {
  value = local.ip_dns_map
}

output "root_passwords" {
  value = random_string.random[*].result
}
