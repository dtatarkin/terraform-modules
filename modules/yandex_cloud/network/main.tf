# Yandex.Cloud VPC Network, Subnets, and Security Groups

resource "yandex_vpc_network" "network" {
  for_each = var.networks
  name     = each.key
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = merge([
    for net_name, net in var.networks : {
      for subnet in net.subnets : "${net_name}-${subnet.name}" => {
        network_id     = yandex_vpc_network.network[net_name].id
        name           = subnet.name
        zone           = subnet.zone
        v4_cidr_blocks = subnet.v4_cidr_blocks
      }
    }
  ]...)

  name           = each.value.name
  zone           = each.value.zone
  network_id     = each.value.network_id
  v4_cidr_blocks = each.value.v4_cidr_blocks
}

resource "yandex_vpc_security_group" "sg" {
  for_each = var.security_groups

  name       = each.key
  network_id = coalesce(each.value.network_id, yandex_vpc_network.network["main"].id)

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      protocol       = ingress.value.protocol
      port           = ingress.value.port
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
      description    = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      protocol       = egress.value.protocol
      port           = egress.value.port
      v4_cidr_blocks = egress.value.v4_cidr_blocks
      description    = egress.value.description
    }
  }
}
