{ pkgs, lib, vars, ... }:
{
  imports = [
    ../all.nix
    ../../secret
    ../../service/linux/system/openssh.nix
  ];

  home-manager.users = {
    ${vars.user.username} = { ... }: {
      imports = [
        ../../package/all/hm/git.nix
        ../../package/all/hm/openssh.nix
        ../../package/all/hm/zsh
      ];

      xdg.enable = true;
    };

    root = { ... }: {
      home = {
        homeDirectory = "/root";
        stateVersion = vars.nixosVersion;
      };

      imports = [
        ../../package/all/hm/zsh
      ];

      xdg.enable = true;
    };
  };

  # System settings
  system.stateVersion = vars.nixosVersion;

  # Internationalization settings
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

  # Networking settings
  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.zsh.shellInit = ''
    autoload -U compinit && compinit -i -d "$HOME/.cache/zsh/zcompdump"
    autoload -U bashcompinit && bashcompinit
  '';

  # User settings
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

  # Activation scripts
  system.activationScripts.setNixosConfigOwner = ''
    chown -R ${vars.user.username}:${vars.user.username} /etc/nixos
    chown -R ${vars.user.username}:${vars.user.username} /opt/config
  '';

  system.activationScripts.setUserPassword = lib.stringAfter [ "users" "agenix" ] ''
    echo "${vars.user.username}:$(cat ${vars.user.password})" | ${pkgs.shadow}/bin/chpasswd
  '';
}
