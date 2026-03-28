output "network_ids" {
  description = "Map of network names to IDs"
  value = {
    for name, net in yandex_vpc_network.network : name => net.id
  }
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    for name, subnet in yandex_vpc_subnet.subnet : name => subnet.id
  }
}

output "security_group_ids" {
  description = "Map of security group names to IDs"
  value = {
    for name, sg in yandex_vpc_security_group.sg : name => sg.id
  }
}
