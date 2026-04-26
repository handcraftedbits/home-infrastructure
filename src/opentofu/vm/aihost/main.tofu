module "aihost" {
  source = "../../modules/vm/nixos"

  cache_dir            = var.cache_dir
  cpu_cores            = 4
  cpu_cores_per_socket = 4
  disk_space           = 500
  esxi                 = var.esxi
  nix                  = var.nix
  extra_config = {
    "pciPassthru.64bitMMIOSizeGB" : "256",
    "pciPassthru.use64bitMMIO" : "true"
  }
  hostname = "aihost.vm.lan.howard.estate"
  http_server = {
    host = var.http_server.host
    port = var.http_server.port
  }
  pci_device_ids = ["0000:41:00.0", "0000:c1:00.0"]
  ram       = 98304
}
