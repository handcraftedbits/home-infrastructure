module "dbhost" {
  source = "../../modules/vm/nixos"

  cache_dir            = var.cache_dir
  cpu_cores            = 2
  cpu_cores_per_socket = 2
  disk_space           = 80
  esxi                 = var.esxi
  nix                  = var.nix
  hostname             = "dbhost.vm.lan.howard.estate"
  http_server = {
    host = var.http_server.host
    port = var.http_server.port
  }
  ram       = 16384
}
