output "hetzner_server_ips" {
  description = "Map of Hetzner server names to IPv4 addresses"
  value       = { for k, v in hcloud_server.nodes : k => v.ipv4_address }
}

output "server_volumes" {
  description = "Map of server names to attached volumes"
  value       = local.server_volumes
}

output "hetzner_servers" {
  description = "Full Hetzner server resources"
  value       = hcloud_server.nodes
}
