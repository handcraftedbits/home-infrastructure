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
    username : "The username for ESXi API access."
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

variable "firmware" {
  description = "The firmware type to use, either BIOS or UEFI"
  type        = string

  validation {
    condition     = var.firmware == "bios" || var.firmware == "efi"
    error_message = "The firmware value must be either 'bios' or 'efi'."
  }
}

variable "guest_id" {
  description = "The guest ID representing the operating system for the VM."
  type        = string
}

variable "hostname" {
  description = "The hostname for the VM."
  type        = string
}

variable "iso" {
  description = "The path to the ISO image that will be installed on the VM."
  type        = string
}

variable "network_name" {
  default     = "VM Network"
  description = "The name of the network the VM will be assigned to."
  type        = string
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
