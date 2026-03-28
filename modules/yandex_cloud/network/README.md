# Yandex Cloud Network Module

Creates VPC networks, subnets, and security groups in Yandex Cloud.

## Usage

```hcl
module "network" {
  source = "./shared-modules/modules/yandex_cloud/network"

  networks = {
    main = {
      subnets = [
        {
          name           = "ru-central1-a"
          zone           = "ru-central1-a"
          v4_cidr_blocks = ["10.1.0.0/24"]
        }
      ]
    }
  }

  security_groups = {
    web = {
      ingress = [
        { protocol = "TCP", port = 443, description = "HTTPS" }
      ]
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `networks` | Map of VPC networks to create | `map(object)` | No |
| `security_groups` | Map of security groups to create | `map(object)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `network_ids` | Map of network names to IDs |
| `subnet_ids` | Map of subnet names to IDs |
| `security_group_ids` | Map of security group names to IDs |
