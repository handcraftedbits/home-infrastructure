module "dns" {
  source = "../modules/network/fortinet/dns"

  dns_zone_name = "_default"
  domain        = "howard.estate"

  aliases = {
    "1ga.esxi.lan" = [
      "esxi.lan"
    ]

    "10ga.esxi.lan" = [
      "nas.lan"
    ]

    "aihost.vm.lan" = [
      "audiocpp.app",
      "aitoolkit.app",
      "comfyui.app",
      "jina.app",
      "labelstudio.app",
      "llm",
      "mcp"
    ]

    "apphost.vm.lan" = [
      "forgejo.app",
      "frontdoor",
      "immich.app",
      "jellyfin.app",
      "linkwarden.app",
      "mermaid.app",
      "navidrome.app",
      "openchamber.app",
      "romm.app",
      "searxng.app",
      "silverbullet.app",
      "vaultwarden.app"
    ]

    "datahost.vm.lan" = [
      "postgresql.db",
      "s3"
    ]

    "dnshost.lan" = [
      "admin.ap1.wlan",
      "admin.vac1.wlan",
      "admin.vac2.wlan",
      "admin.dns.lan",
      "admin.esxi.lan",
      "admin.firewall.lan",
      "admin.ipmi.esxi.lan",
      "admin.nas.lan",
      "makemkv.app"
    ]
  }

  hostnames = {
    "firewall.lan"    = "10.0.0.1"
    "ipmi.esxi.lan"   = "10.0.1.10"
    "1ga.esxi.lan"    = "10.0.1.11"
    "1gb.esxi.lan"    = "10.0.1.12"
    "10ga.esxi.lan"   = "10.0.1.13"
    "10gb.esxi.lan"   = "10.0.1.14"
    "macdesk.lan"     = "10.0.1.20"
    "apphost.vm.lan"  = "10.0.1.30"
    "datahost.vm.lan" = "10.0.1.31"
    "aihost.vm.lan"   = "10.0.1.32"
    "dnshost.lan"     = "10.0.1.22"
    "ps5.lan"         = "10.0.1.23"
    "work.lan"        = "10.0.1.21"
    "ap1.wlan"        = "10.0.3.2"
    "ap2.wlan"        = "10.0.3.3"
    "vac1.wlan"       = "10.0.3.99"
    "vac2.wlan"       = "10.0.3.100"
    "sprinkler.wlan"  = "10.0.3.101"
  }
}
