variable "zone_name" {
  description = "Label for the DNS zone resource"
  type        = string
}

variable "zone_domain" {
  description = "FQDN of the DNS zone (with trailing dot)"
  type        = string
}

variable "dns_records" {
  description = "Map of DNS records to create in the zone (key is arbitrary identifier)"
  type = map(object({
    name = string
    type = string
    ttl  = number
    data = list(string)
  }))
  default = {}
}

variable "ns_servers" {
  description = "NS servers for the DNS zone (used in outputs for delegation)"
  type        = list(string)
}
