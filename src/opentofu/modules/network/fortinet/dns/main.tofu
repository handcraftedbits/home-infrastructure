resource "fortios_system_dnsdatabase" "default" {
  authoritative         = var.authoritative ? "enable" : "disable"
  domain                = var.domain
  name                  = var.dns_zone_name
  status                = var.status
  ttl                   = var.ttl
  type                  = var.type
  dynamic_sort_subtable = "natural"
  update_if_exist       = true
  view                  = var.view

  dynamic "dns_entry" {
    for_each = local.dns_entries
    iterator = entry

    content {
      canonical_name = entry.value.canonical_name
      hostname       = entry.key
      ip             = entry.value.ip
      status         = "enable"
      type           = entry.value.type
    }
  }
}
