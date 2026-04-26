module "app" {
  source = "../../modules/vm/nixos"

  cache_dir            = var.cache_dir
  cpu_cores            = 4
  cpu_cores_per_socket = 4
  disk_space           = 80
  esxi                 = var.esxi
  nix                  = var.nix
  hostname             = "apphost.vm.lan.howard.estate"
  http_server = {
    host = var.http_server.host
    port = var.http_server.port
  }
  ram       = 32768
}
