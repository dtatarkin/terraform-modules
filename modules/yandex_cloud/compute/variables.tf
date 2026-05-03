variable "ssh_keys" {
  description = "Map of SSH keys (name -> public key)"
  type        = map(string)
  default     = {}
}

variable "servers" {
  description = "Map of compute instances to create"
  type = map(object({
    platform_id        = string
    cores              = number
    memory             = number
    disk_size          = number
    disk_type          = optional(string, "network-hdd")
    image_id           = optional(string, "")
    core_fraction      = optional(number, 100)
    zone               = string
    subnet_id          = string
    security_group_ids = optional(list(string), [])
    docker_host        = optional(bool, false)
    k3s_role           = optional(string)
    nat_ip_address     = optional(string)
  }))
  default = {}
}
