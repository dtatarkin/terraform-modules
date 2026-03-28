output "instances" {
  description = "Map of created compute instances"
  value       = yandex_compute_instance.server
}

output "server_ips" {
  description = "Map of server names to public IPs"
  value = {
    for name, instance in yandex_compute_instance.server :
    name => instance.network_interface[0].nat_ip_address
  }
}
