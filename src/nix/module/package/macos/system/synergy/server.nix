{ config, pkgs, vars, ... }:
let
  # Run from the stable copy nix-darwin makes, not from the store, so the bundle is easy to find in System Settings.
  execPath = "/Applications/Nix Apps/Synergy Server.app/Contents/MacOS/Synergy Server";

  # A bundle with a stable identity, so that the Accessibility grant survives rebuilds; see README.md.
  synergyServer = config.lib.appIdentity.mkAppBundle {
    executable = "${pkgs.synergy}/bin/.synergys-wrapped";
    identifier = "com.curtisshoward.synergys";
    mainProgram = "synergys";
    name = "Synergy Server";
  };
in
{
  environment.etc."synergy/synergy.conf".text = import ./synergy.conf.nix { inherit vars; };

  environment.systemPackages = [
    synergyServer
  ];

  launchd.user.agents.synergy = {
    serviceConfig = {
      KeepAlive = true;
      Label = "com.synergy";
      ProgramArguments = [ execPath "-c" "/etc/synergy/synergy.conf" "-f" ];
      RunAtLoad = true;
    };
  };
}
