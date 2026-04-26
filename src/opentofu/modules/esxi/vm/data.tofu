data "vsphere_datacenter" "default" {
  name = var.esxi.datacenter_name
}

data "vsphere_datastore" "iso" {
  datacenter_id = data.vsphere_datacenter.default.id
  name          = var.esxi.storage.datastore_iso
}

data "vsphere_datastore" "vm" {
  datacenter_id = data.vsphere_datacenter.default.id
  name          = var.esxi.storage.datastore_vm
}

data "vsphere_host" "default" {
  datacenter_id = data.vsphere_datacenter.default.id
  name          = var.esxi.hostname
}

data "vsphere_network" "default" {
  datacenter_id = data.vsphere_datacenter.default.id
  name          = var.network_name
}

data "vsphere_resource_pool" "default" {
  datacenter_id = data.vsphere_datacenter.default.id
  name          = local.esxi.resource_pool_name
}
