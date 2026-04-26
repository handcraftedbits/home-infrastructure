data "fortios_systemdhcp_serverlist" "default" {
  filter = "interface==${var.interface.name}"
}
