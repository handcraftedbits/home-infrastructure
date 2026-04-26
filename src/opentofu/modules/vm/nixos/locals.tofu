# noinspection HttpUrlsUsage
locals {
  age_private_key     = "/opt/container/age.key"
  bootstrap_url       = "http://${var.http_server.host}:${var.http_server.port}/bootstrap.json"
  iso_filename        = "nixos-${replace(local.bootstrap_url, "/[^a-zA-Z0-9]/", "_")}.iso"
  short_hostname      = split(".", var.hostname)[0]
}
