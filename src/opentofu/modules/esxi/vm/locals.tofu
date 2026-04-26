locals {
  esxi = {
    resource_pool_name = "/${var.esxi.datacenter_name}/host/${var.esxi.hostname}/Resources"
  }

  hostname_md5 = md5(var.hostname)

  pci_device_ids = join(" ", var.pci_device_ids)

  vm = {
    mac = join(":", [
      "02",
      substr(local.hostname_md5, 0, 2),
      substr(local.hostname_md5, 2, 2),
      substr(local.hostname_md5, 4, 2),
      substr(local.hostname_md5, 6, 2),
      substr(local.hostname_md5, 8, 2)
    ])
  }
}
