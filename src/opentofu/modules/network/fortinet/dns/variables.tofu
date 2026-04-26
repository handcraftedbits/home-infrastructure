variable "aliases" {
  description = <<-EOT
  A map of target hostnames to a list of CNAME aliases that point to it.

  aliases = {
    "host.lan" = ["alias1.lan", "alias2.lan"]
  }
  EOT

  type = map(list(string))
  default = {}
}

variable "authoritative" {
  description = "Whether or not the DNS zone is authoritative."
  type        = bool
  default     = true
}

variable "dns_zone_name" {
  description = "The name of the FortiOS DNS database zone."
  type        = string
}

variable "domain" {
  description = "The DNS zone domain name."
  type        = string
}

variable "hostnames" {
  description = <<-EOT
  A map of hostnames to IP addresses.

  hostnames = {
    "host.lan" = "10.0.0.1"
  }
  EOT

  type = map(string)
}

variable "status" {
  description = "Enable or disable the DNS database zone."
  type        = string
  default     = "enable"
}

variable "ttl" {
  description = "Default TTL for records in seconds."
  type        = number
  default     = 86400
}

variable "type" {
  description = "The DNS zone type to use."
  type        = string
  default     = "primary"
}

variable "view" {
  description = "The DNS zone view."
  type        = string
  default     = "shadow"
}

