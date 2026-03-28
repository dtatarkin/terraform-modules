# Terraform Shared Modules

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.6-yellow?logo=opentofu)](https://opentofu.org/)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-purple?logo=terraform)](https://www.terraform.io/)

Production-ready, reusable OpenTofu/Terraform modules for provisioning cloud infrastructure on **Hetzner Cloud** and **Yandex Cloud**.

---

## Features

- **Multi-cloud** -- consistent module interface across Hetzner and Yandex Cloud
- **Composable** -- modules chain together (network -> compute -> dns) with shared outputs
- **Secure by default** -- firewalls, security groups, KMS encryption, IAM service accounts
- **Batteries included** -- working examples for both providers

## Modules

### Hetzner Cloud

| Module | Description | Resources |
|--------|-------------|-----------|
| [network](modules/hetzner/network) | Private networks, subnets, and firewalls | `hcloud_network`, `hcloud_network_subnet`, `hcloud_firewall` |
| [compute](modules/hetzner/compute) | Servers, SSH keys, and volumes | `hcloud_server`, `hcloud_ssh_key`, `hcloud_volume` |
| [dns](modules/hetzner/dns) | DNS zones and records | `hcloud_zone`, `hcloud_zone_rrset` |

### Yandex Cloud

| Module | Description | Resources |
|--------|-------------|-----------|
| [network](modules/yandex_cloud/network) | VPC networks, subnets, and security groups | `yandex_vpc_network`, `yandex_vpc_subnet`, `yandex_vpc_security_group` |
| [compute](modules/yandex_cloud/compute) | Compute instances | `yandex_compute_instance` |
| [dns](modules/yandex_cloud/dns) | DNS zones and records | `yandex_dns_zone`, `yandex_dns_recordset` |
| [storage](modules/yandex_cloud/storage) | S3 buckets with KMS encryption and IAM | `yandex_storage_bucket`, `yandex_kms_symmetric_key`, `yandex_iam_service_account` |

## Quick Start

### 1. Add as a git submodule

```bash
git submodule add <repo-url> tofu/shared-modules
```

### 2. Use modules in your configuration

```hcl
# --- Networking ---
module "network" {
  source = "./shared-modules/modules/hetzner/network"

  hetzner_networks = {
    internal = {
      ip_range = "10.0.0.0/16"
      subnets = {
        default = {
          ip_range         = "10.0.1.0/24"
          network_zone     = "eu-central"
        }
      }
    }
  }

  hetzner_firewalls = {
    web = {
      rules = [
        { direction = "in", protocol = "tcp", port = "80",  source_ips = ["0.0.0.0/0", "::/0"] },
        { direction = "in", protocol = "tcp", port = "443", source_ips = ["0.0.0.0/0", "::/0"] },
      ]
    }
  }
}

# --- Compute ---
module "compute" {
  source = "./shared-modules/modules/hetzner/compute"

  ssh_keys     = { admin = file("~/.ssh/id_ed25519.pub") }
  firewall_ids = module.network.firewall_ids
  network_ids  = module.network.network_ids

  hetzner_servers = {
    web-1 = {
      server_type = "cx22"
      image       = "ubuntu-24.04"
      location    = "hel1"
      firewalls   = ["web"]
    }
  }
}

# --- DNS ---
module "dns" {
  source = "./shared-modules/modules/hetzner/dns"

  dns_zone_name  = "example.com"
  dns_subdomain  = "infra"
  server_public_ips = module.compute.hetzner_server_ips
}
```

> See the [examples/](examples/) directory for complete, runnable configurations for both providers.

## Requirements

| Dependency | Version |
|------------|---------|
| OpenTofu / Terraform | >= 1.6 |
| Hetzner Cloud provider | ~> 1.44 |
| Yandex Cloud provider | ~> 0.192 |

## Project Structure

```
shared-modules/
├── modules/
│   ├── hetzner/
│   │   ├── network/       # Networks, subnets, firewalls
│   │   ├── compute/       # Servers, SSH keys, volumes
│   │   └── dns/           # DNS zones and records
│   └── yandex_cloud/
│       ├── network/       # VPC, subnets, security groups
│       ├── compute/       # Compute instances
│       ├── dns/           # DNS zones and records
│       └── storage/       # S3 buckets, KMS, IAM
└── examples/
    ├── hetzner/           # Full Hetzner stack example
    └── yandex_cloud/      # Full Yandex Cloud stack example
```

## License

[MIT](LICENSE)
