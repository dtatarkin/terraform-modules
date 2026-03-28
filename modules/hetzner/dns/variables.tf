variable "dns_zone_name" {
  description = "DNS zone managed in Hetzner DNS (root domain)"
  type        = string
}

variable "dns_subdomain" {
  description = "Subdomain prefix for infra records within the zone"
  type        = string
}

variable "dns_default_ttl" {
  description = "Default TTL for DNS records (seconds)"
  type        = number
}

variable "dns_extra_records" {
  description = "Extra DNS records (nebula IPs, service CNAMEs, etc.)"
  type = map(object({
    type  = string
    value = string
    ttl   = optional(number)
  }))
}

variable "server_public_ips" {
  description = "Map of server names to public IPv4 addresses"
  type        = map(string)
  default     = {}
}
