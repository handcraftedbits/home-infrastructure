variable "interface" {
  description = <<-EOT
  interface = {
    dns = {
      server : "The IP address of the upstream DNS server to use."
    }
    domain  : "The root domain name to use."
    gateway : "The IP address of the gateway to use."
    ip_range = {
      end   : "The end of the DHCP IP address range to use."
      start : "The start of the DHCP IP address range to use."
    }
    name    : "The name to use for the DHCP server."
    netmask : "The IP address netmask to use."
  }
  EOT

  type = object({
    dns = object({
      server = string
    })
    domain  = string
    gateway = string
    ip_range = object({
      end   = string
      start = string
    })
    name = string
    netmask = optional(string, "255.255.255.0")
  })
}

variable "reservations" {
  description = <<-EOT
  reservations = {
    ip_address  : "The IP address to reserve for the MAC address."
    mac_address : "The MAC address for which an IP address will be reserved."
  }
  EOT

  type = list(
    object({
      ip_address  = string
      mac_address = string
    })
  )
}

