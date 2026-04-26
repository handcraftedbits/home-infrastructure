module "dhcp" {
  source = "../modules/network/fortinet/dhcp"

  interface = {
    dns = {
      server = "10.0.0.1"
    }
    domain  = "howard.estate"
    gateway = "10.0.1.1"
    ip_range = {
      end   = "10.0.1.254"
      start = "10.0.1.2"
    }
    name = "_default"
  }

  reservations = [
    {
      ip_address  = "10.0.1.10"
      mac_address = "10:FF:E0:74:D5:76"
    },
    {
      ip_address  = "10.0.1.11"
      mac_address = "10:FF:E0:74:D5:74"
    },
    {
      ip_address  = "10.0.1.12"
      mac_address = "10:FF:E0:74:D5:75"
    },
    {
      ip_address  = "10.0.1.13"
      mac_address = "68:05:CA:C3:7A:54"
    },
    {
      ip_address  = "10.0.1.14"
      mac_address = "68:05:CA:C3:7A:55"
    },
    {
      ip_address  = "10.0.1.20"
      mac_address = "30:9C:23:A8:4D:FD"
    },
    {
      ip_address  = "10.0.1.21",
      mac_address = "14:98:77:4F:E7:95"
    },
    {
      ip_address  = "10.0.1.22",
      mac_address = "A8:20:66:0D:B0:50"
    },
    {
      ip_address  = "10.0.1.23",
      mac_address = "28:40:DD:2A:C1:E0"
    },
    {
      ip_address  = "10.0.1.30",
      mac_address = "02:AF:BE:11:04:F3"
    },
    {
      ip_address  = "10.0.1.31",
      mac_address = "02:1E:8F:2C:58:0E"
    },
    {
      ip_address  = "10.0.1.32",
      mac_address = "02:13:B7:8F:D1:C1"
    }
  ]
}
