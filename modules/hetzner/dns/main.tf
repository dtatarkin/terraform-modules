resource "hcloud_zone" "infra" {
  name = var.dns_zone_name
  mode = "primary"
  ttl  = var.dns_default_ttl
}

resource "hcloud_zone_rrset" "server_public" {
  for_each = var.server_public_ips

  zone = hcloud_zone.infra.name
  name = "${each.key}.public.${var.dns_subdomain}"
  type = "A"
  ttl  = var.dns_default_ttl

  records = [
    { value = each.value }
  ]
}

resource "hcloud_zone_rrset" "extra" {
  for_each = var.dns_extra_records

  zone = hcloud_zone.infra.name
  name = "${each.key}.${var.dns_subdomain}"
  type = each.value.type
  ttl  = coalesce(each.value.ttl, var.dns_default_ttl)

  records = [
    { value = each.value.value }
  ]
}
