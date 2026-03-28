resource "yandex_dns_zone" "this" {
  name   = var.zone_name
  zone   = var.zone_domain
  public = true
}

resource "yandex_dns_recordset" "this" {
  for_each = var.dns_records

  zone_id = yandex_dns_zone.this.id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  data    = each.value.data
}
