variable "hetzner_networks" {
  description = "Map of Hetzner private networks to create"
  type = map(object({
    ip_range = string
    subnets = list(object({
      type         = optional(string, "cloud")
      ip_range     = string
      network_zone = string
    }))
  }))
  default = {}
}

variable "hetzner_firewalls" {
  description = "Map of Hetzner Cloud firewalls to create"
  type = map(object({
    labels = optional(map(string), {})
    rules = list(object({
      direction       = string
      protocol        = string
      port            = optional(string)
      source_ips      = optional(list(string), [])
      destination_ips = optional(list(string), [])
      description     = optional(string, "")
    }))
  }))
  default = {}
}
