output "nameservers" {
  description = "Authoritative nameservers for the DNS zone"
  value       = hcloud_zone.infra.authoritative_nameservers
}

output "zone_name" {
  description = "Managed DNS zone name"
  value       = hcloud_zone.infra.name
}

output "public_records" {
  description = "Public A records for servers"
  value       = hcloud_zone_rrset.server_public
}

output "extra_records" {
  description = "Extra DNS records"
  value       = hcloud_zone_rrset.extra
}
