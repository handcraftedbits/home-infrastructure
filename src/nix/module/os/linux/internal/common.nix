{ pkgs, vars, ... }:
let
  util = import ../../../util { inherit vars; };
in
{
  imports = [
    ../common.nix
    ../../../package/linux/system/podman.nix
  ];

  home-manager.users = {
    ${vars.user.username} = { ... }: {
      imports = [
        ../../../package/all/hm/neovim
        ../../../package/all/hm/tmux
      ];
    };

    root = { ... }: {
      imports = [
        ../../../package/all/hm/neovim
        ../../../package/all/hm/tmux
      ];
    };
  };

  # System settings
  boot = {
    kernel.sysctl = {
      # Improve networking performance.
      "net.core.rmem_max" = 2500000;
      "net.core.wmem_max" = 2500000;
      # Allow Traefik to start on port 80.
      "net.ipv4.ip_unprivileged_port_start" = 80;
      # Improve networking performance.
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 87380 16777216";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    netcat-openbsd
    pciutils
  ];
}
