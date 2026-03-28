output "zone_id" {
  description = "ID of the created DNS zone"
  value       = yandex_dns_zone.this.id
}

output "zone_ns_servers" {
  description = "NS servers for the DNS zone (use for delegation)"
  value       = var.ns_servers
}
