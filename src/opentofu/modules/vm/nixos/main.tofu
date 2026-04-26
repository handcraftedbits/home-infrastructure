module "esxi_vm" {
  source = "../../esxi/vm"
  depends_on = [null_resource.start_host]

  cpu_cores            = var.cpu_cores
  cpu_cores_per_socket = var.cpu_cores_per_socket
  disk_space           = var.disk_space
  esxi                 = var.esxi
  extra_config         = var.extra_config
  firmware             = "efi"
  guest_id             = "other6xLinux64Guest"
  hostname             = var.hostname
  iso                  = "/opt/container/cache/iso/${local.iso_filename}"
  network_name         = var.network_name
  pci_device_ids       = var.pci_device_ids
  ram                  = var.ram
}

resource "null_resource" "iso" {
  triggers = {
    run = "once"
  }

  provisioner "local-exec" {
    command = "/opt/container/bin/nixos/build-iso.sh"
    environment = {
      BUILD_ISO_BOOTSTRAP_URL = local.bootstrap_url
      BUILD_ISO_CACHE_DIR     = "${var.cache_dir}/iso"
      BUILD_ISO_FILENAME      = local.iso_filename
    }
  }
}

resource "null_resource" "start_host" {
  depends_on = [null_resource.iso]

  triggers = {
    run = "once"
  }

  provisioner "local-exec" {
    command = "/opt/container/bin/nixos/start-host.sh"
    environment = {
      START_HOST_ANONYMOUS_FLAKE_URL = "${var.nix.anonymous_flake_url}"
      START_HOST_AGE_PRIVATE_KEY     = local.age_private_key
      START_HOST_FLAKE_PATH          = var.nix.flake_path
      START_HOST_FLAKE_URL           = var.nix.flake_url
      START_HOST_HOST                = var.http_server.host
      START_HOST_PORT                = var.http_server.port
      START_HOST_TYPE                = "vm"
      START_HOST_VM_HOSTNAME         = local.short_hostname
    }
  }
}

resource "null_resource" "stop_host" {
  depends_on = [module.esxi_vm]

  triggers = {
    run = "once"
  }

  provisioner "local-exec" {
    command = "/opt/container/bin/nixos/stop-host.sh"
  }
}
