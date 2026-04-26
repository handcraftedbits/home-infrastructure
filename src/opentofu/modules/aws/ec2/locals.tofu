locals {
  user_data = templatefile("${path.module}/data/user_data.template", {
    age_key = base64encode(file("/opt/container/age.key"))
    anonymous_flake_url = var.nix.anonymous_flake_url
    configuration_nix = base64encode(file("${path.module}/data/etc/nixos/configuration.nix"))
    flake_host          = var.flake_host
    flake_path          = var.nix.flake_path
    flake_url           = var.nix.flake_url
  })
}
