# Example: Complete Hetzner Cloud infrastructure setup

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44"
    }
  }
}

module "network" {
  source = "../../modules/hetzner/network"

  hetzner_networks = {
    internal = {
      ip_range = "10.0.0.0/16"
      subnets = [
        {
          ip_range     = "10.0.1.0/24"
          network_zone = "eu-central"
        }
      ]
    }
  }

  hetzner_firewalls = {
    web = {
      rules = [
        { direction = "in", protocol = "tcp", port = "80", source_ips = ["0.0.0.0/0", "::/0"], description = "HTTP" },
        { direction = "in", protocol = "tcp", port = "443", source_ips = ["0.0.0.0/0", "::/0"], description = "HTTPS" },
        { direction = "in", protocol = "tcp", port = "22", source_ips = ["0.0.0.0/0", "::/0"], description = "SSH" },
      ]
    }
  }
}

module "compute" {
  source = "../../modules/hetzner/compute"

  ssh_keys = {
    admin = "ssh-ed25519 AAAA... admin@example.com"
  }

  hetzner_servers = {
    web1 = {
      server_type = "cx22"
      image       = "ubuntu-24.04"
      location    = "hel1"
      firewalls   = ["web"]
      networks    = { internal = "" }
    }
  }

  hetzner_volumes = {
    data = {
      size     = 20
      location = "hel1"
      server   = "web1"
    }
  }

  firewall_ids = module.network.firewall_ids
  network_ids  = module.network.network_ids
}

module "dns" {
  source = "../../modules/hetzner/dns"

  dns_zone_name     = "example.com"
  dns_subdomain     = "infra"
  dns_default_ttl   = 300
  dns_extra_records = {}
  server_public_ips = module.compute.hetzner_server_ips
}
