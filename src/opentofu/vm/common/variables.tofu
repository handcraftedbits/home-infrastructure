variable "cache_dir" {
  description = "The directory where cached files are stored."
  type        = string
}

variable "esxi" {
  description = <<-EOT
  esxi = {
    datacenter_name : "The name of the datacenter to use."
    hostname        : "The hostname of the ESXi server."
    password        : "The password for ESXi API access."
    storage : {
      datastore_iso : "The name of the datastore where ISO images will be stored."
      datastore_vm  : "The name of the datastore where VMs will be stored."
      iso_path      : "The datastore path where ISO images will be stored."
    }
    username : "The username for ESXi API access."
  }
  EOT

  type = object({
    datacenter_name = optional(string, "ha-datacenter")
    hostname = string
    password = string
    storage = object({
      datastore_iso = string
      datastore_vm  = string
      iso_path = optional(string, "iso")
    })
    username = string
  })
}

variable "http_server" {
  description = <<-EOT
  http_server = {
    host : "The host the embedded HTTP server will listen on."
    port : "The port the embedded HTTP server will listen on."
  }
  EOT

  type = object({
    host = string,
    port = number
  })
}

variable "nix" {
  description = <<-EOT
  nix = {
    anonymous_flake_url : "The URL of the Nix flake to use which can be accessed anonymously."
    flake_path          : "The relative path under /opt/config where flake.nix is located."
    flake_url           : "The URL of the Nix flake to use."
  }
  EOT

  type = object({
    anonymous_flake_url = string
    flake_path          = string
    flake_url           = string
  })
}
