{ pkgs, lib, vars, ... }:
{
  # Imports.
  imports = [
    ../package/podman.nix
    ../secret
    ../service/openssh.nix
  ];

  home-manager.users = {
    ${vars.user.username} = { ... }: {
      imports = [
        ../package/git.nix
        ../package/neovim/neovim.nix
        ../package/openssh.nix
        ../package/tmux/tmux.nix
        ../package/zsh/zsh.nix
      ];
    };

    root = { ... }: {
      home = {
        homeDirectory = "/root";
        stateVersion = vars.nixosVersion;
      };
      imports = [
        ../package/neovim/neovim.nix
        ../package/tmux/tmux.nix
        ../package/zsh/zsh.nix
      ];
    };
  };

  # Critical settings.
  system.stateVersion = vars.nixosVersion;

  boot = {
    kernel = {
      sysctl = {
        # Improve networking performance.
        "net.core.rmem_max" = 2500000;
        "net.core.wmem_max" = 2500000;
        # Allow Traefik to start on port 80.
        "net.ipv4.ip_unprivileged_port_start" = 80;
        # Improve networking performance.
        "net.ipv4.tcp_rmem" = "4096 87380 16777216";
        "net.ipv4.tcp_wmem" = "4096 87380 16777216";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  # Internationalization settings.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Networking settings.
  networking = {
    firewall.enable = false;
    hostName = vars.hostName;
    networkmanager.enable = true;
  };

  # Nix settings.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.activationScripts.nixos-owner = ''
    chown -R ${vars.user.username}:${vars.user.username} /etc/nixos
    chown -R ${vars.user.username}:${vars.user.username} /opt/config
  '';

  # Package settings.
  environment.systemPackages = with pkgs; [
    age
    curl
    fd
    file
    jq
    netcat-openbsd
    pciutils
    ripgrep
    wget
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Time settings.
  time.timeZone = vars.timeZone;

  # User settings.
  users = {
    defaultUserShell = pkgs.zsh;
    groups.${vars.user.username}.gid = vars.user.gid or 1000;
    users.${vars.user.username} = {
      description = vars.user.fullName;
      extraGroups = [ "networkmanager" "wheel" ];
      group = vars.user.username;
      isNormalUser = true;
      linger = true;
      uid = vars.user.uid or 1000;
    };
  };

  system.activationScripts.setUserPassword = lib.stringAfter [ "users" "agenix" ] ''
    echo "${vars.user.username}:$(cat ${vars.user.password})" | ${pkgs.shadow}/bin/chpasswd
  '';

  # Zsh settings.
  programs.zsh.enable = true;
}
