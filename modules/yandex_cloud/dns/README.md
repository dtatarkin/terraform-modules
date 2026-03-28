# Yandex Cloud DNS Module

Creates DNS zones and records in Yandex Cloud.

## Usage

```hcl
module "dns" {
  source = "./shared-modules/modules/yandex_cloud/dns"

  zone_name   = "example-com"
  zone_domain = "example.com."
  ns_servers  = ["ns1.yandexcloud.net.", "ns2.yandexcloud.net."]

  dns_records = {
    web = { name = "www", type = "A", ttl = 300, data = ["1.2.3.4"] }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `zone_name` | Label for the DNS zone resource | `string` | Yes |
| `zone_domain` | FQDN of the DNS zone (with trailing dot) | `string` | Yes |
| `dns_records` | Map of DNS records to create | `map(object)` | No |
| `ns_servers` | NS servers for the DNS zone | `list(string)` | Yes |

## Outputs

| Name | Description |
|------|-------------|
| `zone_id` | ID of the created DNS zone |
| `zone_ns_servers` | NS servers for the DNS zone |
