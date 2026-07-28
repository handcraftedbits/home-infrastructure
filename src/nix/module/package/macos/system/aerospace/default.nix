{ lib, vars, ... }:
let
  util = import ../../../../util { inherit vars; };

  aerospaceApp = util.mkSignedApp {
    name = "AeroSpace";
    executableName = "AeroSpace";
    bundle = "/Users/${vars.user.username}/Applications/Home Manager Apps/AeroSpace.app";
    deep = true;
    onChange = ''/bin/launchctl kickstart -k "gui/$(id -u)/org.nix-community.home.aerospace" || true'';
  };

  disabledHotKeys = with hotkeyEnums; [
    ctrlLeft
    ctrlRight
    ctrlUp
    ctrl1
    ctrl2
    ctrl3
  ];

  hotkeyEnums = {
    ctrl1 = 118;
    ctrl2 = 119;
    ctrl3 = 120;
    ctrlLeft = 79;
    ctrlRight = 81;
    ctrlUp = 32;
  };
in
{
  imports = [ aerospaceApp.module ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./aerospace-hm.nix
    ];

    launchd.agents.aerospace.config.Program = lib.mkForce aerospaceApp.execPath;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = lib.listToAttrs (
        map (id: {
          name = builtins.toString id;
          value = { enabled = false; };
        }) disabledHotKeys);
    };
  };

  system.activationScripts.postActivation.text = ''
    sudo -u curtiss /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
