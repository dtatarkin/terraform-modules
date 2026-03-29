# Yandex.Cloud Compute Instances

resource "yandex_compute_instance" "server" {
  for_each = var.servers

  name        = each.key
  platform_id = each.value.platform_id
  zone        = each.value.zone

  allow_stopping_for_update = true

  resources {
    cores         = each.value.cores
    core_fraction = each.value.core_fraction
    memory        = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = each.value.image_id
      size     = each.value.disk_size
      type     = each.value.disk_type
    }
  }

  network_interface {
    subnet_id          = each.value.subnet_id
    security_group_ids = each.value.security_group_ids
    nat                = true #checkov:skip=CKV_YC_2:Public IP is required for VPS
  }

  metadata = {
    ssh-keys = join("\n", [for name, key in var.ssh_keys : "ubuntu:${key}"])
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}
