{ pkgs, lib, modulesPath, vars, ... }:
{
  # Imports.
  imports = [
    ../secret
    ../service/openssh.nix
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ../package/git.nix
      ../package/openssh.nix
      ../package/zsh/zsh.nix
    ];
  };

  # Critical settings.
  ec2.efi = true;
  system.stateVersion = vars.nixosVersion;

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
  '';

  # Package settings.
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
