{ pkgs, system, vars, ... }:
let
  util = import ../../util { inherit vars; };
in
{
  imports = [
    ./fonts.nix
    ./homebrew.nix
    ./secrets.nix
    ./zsh.nix
    ./settings
    ../all.nix
    ../../package/all/system/java.nix
    ../../package/macos/system/aerospace
    ../../package/macos/system/docker-desktop.nix
    ../../package/macos/system/kitty
    ../../package/macos/system/sensible-side-buttons.nix
    ../../package/macos/system/synergy
    util.mkDefaultMounts
  ];

  # System settings
  system = {
    primaryUser = vars.user.username;
    stateVersion = 5;
  };

  # User settings
  users.users.${vars.user.username} = {
    home = "/Users/${vars.user.username}";
  };

  # Packages
  environment.systemPackages = with pkgs; [
    appcleaner
    claude-code
    google-chrome
    jetbrains.idea
  ];
}
