{ ... }:
{
  imports = [
    ./common.nix
  ];

  # System settings
  virtualisation.vmware.guest.enable = true;
}
