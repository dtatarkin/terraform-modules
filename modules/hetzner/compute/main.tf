resource "hcloud_ssh_key" "keys" {
  for_each   = var.ssh_keys
  name       = each.key
  public_key = each.value
}

resource "hcloud_server" "nodes" {
  for_each = var.hetzner_servers

  name         = each.key
  server_type  = each.value.server_type
  image        = each.value.image
  location     = each.value.location
  ssh_keys     = [for k in hcloud_ssh_key.keys : k.id]
  firewall_ids = [for fw_name in each.value.firewalls : var.firewall_ids[fw_name]]

  labels = {
    managed_by = "tofu"
  }
}

resource "hcloud_volume" "volumes" {
  for_each = var.hetzner_volumes

  name     = each.key
  size     = each.value.size
  location = each.value.location

  labels = {
    managed_by = "tofu"
  }
}

resource "hcloud_volume_attachment" "attachments" {
  for_each = var.hetzner_volumes

  volume_id = hcloud_volume.volumes[each.key].id
  server_id = hcloud_server.nodes[each.value.server].id
  automount = false
}

locals {
  server_volumes = {
    for name, vol in var.hetzner_volumes : vol.server => {
      name       = name
      volume_id  = hcloud_volume.volumes[name].id
      size       = vol.size
      device     = "/dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volumes[name].id}"
      mount_path = coalesce(vol.mount_path, "/mnt/${name}")
    }...
  }

  server_network_attachments = flatten([
    for server_name, server in var.hetzner_servers : [
      for net_name, ip in server.networks : {
        key          = "${server_name}-${net_name}"
        server_name  = server_name
        network_name = net_name
        ip           = ip
      }
    ]
  ])
}

resource "hcloud_server_network" "attachments" {
  for_each = { for a in local.server_network_attachments : a.key => a }

  server_id  = hcloud_server.nodes[each.value.server_name].id
  network_id = var.network_ids[each.value.network_name]
  ip         = each.value.ip != "" ? each.value.ip : null
}
