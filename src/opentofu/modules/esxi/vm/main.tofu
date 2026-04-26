resource "vsphere_file" "iso" {
  datacenter       = data.vsphere_datacenter.default.name
  datastore        = data.vsphere_datastore.iso.name
  destination_file = "${var.esxi.storage.iso_path}/${basename(var.iso)}"
  source_file      = var.iso
}

resource "null_resource" "remove_cdrom_and_add_pci_devices" {
  depends_on = [vsphere_virtual_machine.vm]

  triggers = {
    run = "once"
  }

  provisioner "local-exec" {
    command = "/opt/container/bin/remove-cdrom-and-add-pci-devices.sh"
    environment = {
      GOVC_INSECURE  = "true"
      GOVC_PASSWORD  = var.esxi.password
      GOVC_URL       = "https://${var.esxi.hostname}"
      GOVC_USERNAME  = var.esxi.username
      PCI_DEVICE_IDS = local.pci_device_ids
      VM_NAME        = var.hostname
    }
  }
}

resource "vsphere_virtual_machine" "vm" {
  depends_on = [vsphere_file.iso]

  datastore_id         = data.vsphere_datastore.vm.id
  firmware             = var.firmware
  guest_id             = var.guest_id
  host_system_id       = data.vsphere_host.default.id
  memory               = var.ram
  memory_reservation   = length(var.pci_device_ids) > 0 ? var.ram : null
  name                 = var.hostname
  num_cores_per_socket = var.cpu_cores_per_socket
  num_cpus             = var.cpu_cores
  resource_pool_id     = data.vsphere_resource_pool.default.id
  wait_for_guest_net_timeout = 20
  wait_for_guest_ip_timeout  = 20

  cdrom {
    datastore_id = data.vsphere_datastore.iso.id
    path         = "${var.esxi.storage.iso_path}/${basename(var.iso)}"
  }

  disk {
    label = "hdd"
    size  = var.disk_space
  }

  extra_config = merge(var.extra_config, {
    "ide0:0.startConnected" = "TRUE"
  })

  lifecycle {
    ignore_changes = [cdrom]
  }

  network_interface {
    adapter_type   = "vmxnet3"
    mac_address    = local.vm.mac
    network_id     = data.vsphere_network.default.id
    use_static_mac = true
  }
}
