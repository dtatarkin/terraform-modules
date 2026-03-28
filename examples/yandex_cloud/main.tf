# Example: Complete Yandex Cloud infrastructure setup

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.192"
    }
  }
}

module "network" {
  source = "../../modules/yandex_cloud/network"

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
        { protocol = "TCP", port = 80, description = "HTTP" },
        { protocol = "TCP", port = 443, description = "HTTPS" },
      ]
      egress = [
        { protocol = "ANY", v4_cidr_blocks = ["0.0.0.0/0"], description = "All outbound" },
      ]
    }
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

module "compute" {
  source = "../../modules/yandex_cloud/compute"

  ssh_keys = {
    admin = "ssh-ed25519 AAAA... admin@example.com"
  }

  servers = {
    web1 = {
      platform_id        = "standard-v3"
      cores              = 2
      memory             = 4
      disk_size          = 20
      zone               = "ru-central1-a"
      subnet_id          = module.network.subnet_ids["main-ru-central1-a"]
      image_id           = data.yandex_compute_image.ubuntu.id
      security_group_ids = [module.network.security_group_ids["web"]]
    }
  }
}

module "dns" {
  source = "../../modules/yandex_cloud/dns"

  zone_name   = "example-com"
  zone_domain = "example.com."
  ns_servers  = ["ns1.yandexcloud.net.", "ns2.yandexcloud.net."]

  dns_records = {
    web = { name = "www", type = "A", ttl = 300, data = [module.compute.server_ips["web1"]] }
  }
}
