variable "networks" {
  description = "Map of VPC networks to create"
  type = map(object({
    subnets = list(object({
      name           = string
      zone           = string
      v4_cidr_blocks = list(string)
    }))
  }))
  default = {}
}

variable "security_groups" {
  description = "Map of security groups to create"
  type = map(object({
    network_id = optional(string)
    ingress = optional(list(object({
      protocol       = string
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
      v4_cidr_blocks = optional(list(string), ["0.0.0.0/0"])
      description    = optional(string, "")
    })), [])
    egress = optional(list(object({
      protocol       = string
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
      v4_cidr_blocks = optional(list(string), ["0.0.0.0/0"])
      description    = optional(string, "")
    })), [])
  }))
  default = {}
}
