{ pkgs, vars, ... }:
let
  util = import ../../../../util { inherit vars; };

  kittyApp = util.mkSignedApp {
    name = "kitty";
    executableName = "kitty";
    bundle = "/Applications/Nix Apps/kitty.app";
    deep = true;
  };
in
{
  imports = [ kittyApp.module ];

  environment.systemPackages = with pkgs; [
    kitty
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./kitty-hm.nix
    ];
  };
}
