# Yandex Cloud Compute Module

Creates compute instances in Yandex Cloud.

## Usage

```hcl
module "compute" {
  source = "./shared-modules/modules/yandex_cloud/compute"

  ssh_keys = {
    admin = "ssh-ed25519 AAAA..."
  }

  servers = {
    web1 = {
      platform_id = "standard-v3"
      cores       = 2
      memory      = 4
      disk_size   = 20
      zone        = "ru-central1-a"
      subnet_id   = module.network.subnet_ids["main-ru-central1-a"]
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `ssh_keys` | Map of SSH keys (name -> public key) | `map(string)` | No |
| `servers` | Map of compute instances to create | `map(object)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `instances` | Map of created compute instances |
| `server_ips` | Map of server names to public IPs |
