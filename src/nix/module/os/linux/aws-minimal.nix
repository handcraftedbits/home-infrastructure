{ pkgs, lib, modulesPath, vars, ... }:
{
  # Imports.
  imports = [
    ./common.nix
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  # System settings
  ec2.efi = true;
}
