data "fortios_systemdhcp_serverlist" "lan" {
  filter = "interface==_default"
}

import {
  id = try(data.fortios_systemdhcp_serverlist.lan.fosidlist[0], null)
  to = module.dhcp.fortios_systemdhcp_server.default
}

import {
  id = "_default"
  to = module.dns.fortios_system_dnsdatabase.default
}
