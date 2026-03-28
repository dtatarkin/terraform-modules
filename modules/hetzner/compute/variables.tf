variable "ssh_keys" {
  description = "Map of SSH keys to register (name → public key)"
  type        = map(string)
}

variable "hetzner_servers" {
  description = "Map of Hetzner servers to create"
  type = map(object({
    server_type = string
    image       = string
    location    = string
    docker_host = optional(bool, false)
    k3s_role    = optional(string)
    firewalls   = optional(list(string), [])
    networks    = optional(map(string), {})
  }))
  default = {}
}

variable "hetzner_volumes" {
  description = "Map of Hetzner Cloud volumes to create and attach to servers"
  type = map(object({
    size       = number
    location   = string
    server     = string
    mount_path = optional(string)
  }))
  default = {}
}

variable "firewall_ids" {
  description = "Map of firewall names to IDs"
  type        = map(string)
  default     = {}
}

variable "network_ids" {
  description = "Map of network names to IDs"
  type        = map(string)
  default     = {}
}
