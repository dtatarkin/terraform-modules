resource "hcloud_network" "networks" {
  for_each = var.hetzner_networks

  name     = each.key
  ip_range = each.value.ip_range
}

locals {
  network_subnets = flatten([
    for net_name, net in var.hetzner_networks : [
      for i, subnet in net.subnets : {
        key          = "${net_name}-${i}"
        network_name = net_name
        type         = subnet.type
        ip_range     = subnet.ip_range
        network_zone = subnet.network_zone
      }
    ]
  ])
}

resource "hcloud_network_subnet" "subnets" {
  for_each = { for s in local.network_subnets : s.key => s }

  network_id   = hcloud_network.networks[each.value.network_name].id
  type         = each.value.type
  ip_range     = each.value.ip_range
  network_zone = each.value.network_zone
}

resource "hcloud_firewall" "firewalls" {
  for_each = var.hetzner_firewalls
  name     = each.key

  labels = merge({ managed_by = "tofu" }, each.value.labels)

  dynamic "rule" {
    for_each = each.value.rules
    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
      description     = rule.value.description
    }
  }
}
