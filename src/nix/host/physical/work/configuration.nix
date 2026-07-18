{ pkgs, vars, ... }:
{
  imports = [
    ./dock.nix
    ../../../module/os/macos
  ];

  age.secrets."wireguard/work/privateKey" = {
    file = ../../../module/secret/wireguard/work/privateKey.age;
    mode = "0400";
  };

  environment.systemPackages = with pkgs; [
    nodejs_24
    postgresql_18
    wireguard-go
    wireguard-tools
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./aerospace.nix
      ./zsh.nix
    ];
  };

  homebrew.casks = [
    "microsoft-outlook"
    "microsoft-teams"
    "slack"
    "zoom"
  ];
}
