{ pkgs, vars, ... }:
let
  util = import ../../../../util { inherit vars; };

  synergyServer = util.mkSignedApp {
    name = "Synergy Server";
    bundleId = "com.curtisshoward.synergys";
    executableName = "synergys";
    binary = "${pkgs.synergy}/bin/.synergys-wrapped";
    onChange = ''/bin/launchctl kickstart -k "gui/$(id -u)/com.synergy" || true'';
  };
in
{
  imports = [ synergyServer.module ];

  environment.etc."synergy/synergy.conf".text = import ./synergy.conf.nix { inherit vars; };

  launchd.user.agents.synergy = {
    serviceConfig = {
      KeepAlive = true;
      Label = "com.synergy";
      ProgramArguments = [ synergyServer.execPath "-c" "/etc/synergy/synergy.conf" "-f" ];
      RunAtLoad = true;
    };
  };
}
