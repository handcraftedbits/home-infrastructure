{ pkgs, vars, ... }:
{
  imports = [
    ./dock.nix
    ../../../module/os/macos
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./aerospace.nix
      ./zsh.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    nodejs_24
  ];

  homebrew.casks = [
    "microsoft-outlook"
    "microsoft-teams"
    "slack"
    "zoom"
  ];
}
