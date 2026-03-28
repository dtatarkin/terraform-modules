output "network_ids" {
  description = "Map of network names to IDs"
  value       = { for k, v in hcloud_network.networks : k => v.id }
}

output "firewall_names" {
  description = "List of firewall names"
  value       = keys(hcloud_firewall.firewalls)
}

output "firewall_ids" {
  description = "Map of firewall names to IDs"
  value       = { for k, v in hcloud_firewall.firewalls : k => v.id }
}
