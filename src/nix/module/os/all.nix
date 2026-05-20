{ lib, pkgs, system, vars, ... }:
let
  isLinux = lib.hasSuffix "-linux" system;
in
{
  # System settings
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    } // (if isLinux
      then { dates = "weekly"; }
      else { interval = { Weekday = 0; Hour = 3; Minute = 15; }; }
    );

    settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  time.timeZone = vars.timeZone;

  # Networking settings
  networking.hostName = vars.hostName;

  # Packages
  environment.systemPackages = with pkgs; [
    age
    awscli
    curl
    fd
    file
    jq
    ripgrep
    wget
  ];
}
