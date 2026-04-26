variable "cache_dir" {
  description = "The directory where cached files are stored."
  type        = string
}

variable "cpu_cores" {
  description = "The number of CPU cores to use."
  type        = number

  validation {
    condition     = var.cpu_cores == floor(var.cpu_cores) && var.cpu_cores > 0
    error_message = "The number of CPU cores must be an integer greater than 0."
  }
}

variable "cpu_cores_per_socket" {
  description = "The number of CPU cores per socket."
  type        = number

  validation {
    condition     = var.cpu_cores_per_socket == floor(var.cpu_cores_per_socket) && var.cpu_cores_per_socket > 0
    error_message = "The number of CPU cores per socket must be an integer greater than 0."
  }
}

variable "disk_space" {
  description = "The amount of disk space to allocate, in GB."
  type        = number

  validation {
    condition     = var.disk_space == floor(var.disk_space) && var.disk_space > 0
    error_message = "The disk space amount must be an integer greater than 0."
  }
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
    username        : "The username for ESXi API access."
  }
  EOT

  type = object({
    datacenter_name = string
    hostname        = string
    password        = string
    storage = object({
      datastore_iso = string
      datastore_vm  = string
      iso_path      = string
    })
    username = string
  })
}

variable "extra_config" {
  default = {}
  description = "Additional configuration that that can be passed to the VM."
  type = map(string)
}

variable "hostname" {
  description = "The hostname for the VM."
  type        = string
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

variable "network_name" {
  default     = "VM Network"
  description = "The name of the network the VM will be assigned to."
  type        = string
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

variable "pci_device_ids" {
  default = []
  description = "A list of PCI device IDs to pass through."
  type = list(string)
}

variable "ram" {
  description = "The amount of RAM to allocate, in MB."
  type        = number

  validation {
    condition     = var.ram == floor(var.ram) && var.ram > 0
    error_message = "The RAM amount must be an integer greater than 0."
  }
}
