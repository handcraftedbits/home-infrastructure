resource "fortios_systemdhcp_server" "default" {
  default_gateway = var.interface.gateway
  dns_server1     = var.interface.dns.server
  dns_service     = "specify"
  domain          = var.interface.domain
  fosid = try(data.fortios_systemdhcp_serverlist.default.fosidlist[0], null)
  interface       = var.interface.name
  netmask         = var.interface.netmask
  ntp_service     = "default"
  status          = "enable"

  ip_range {
    end_ip   = var.interface.ip_range.end
    id       = 1
    start_ip = var.interface.ip_range.start
  }

  dynamic "reserved_address" {
    for_each = local.sorted_reservations

    content {
      action = "reserved"
      ip     = reserved_address.value.ip_address
      mac = lower(reserved_address.value.mac_address)
    }
  }
}
