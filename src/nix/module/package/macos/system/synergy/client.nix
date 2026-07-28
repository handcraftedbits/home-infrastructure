{ pkgs, vars, ... }:
let
  util = import ../../../../util { inherit vars; };

  synergyClient = util.mkSignedApp {
    name = "Synergy Client";
    bundleId = "com.curtisshoward.synergyc";
    executableName = "synergyc";
    binary = "${pkgs.synergy}/bin/.synergyc-wrapped";
    onChange = ''/bin/launchctl kickstart -k "gui/$(id -u)/com.synergy" || true'';
  };
in
{
  imports = [ synergyClient.module ];

  launchd.user.agents = {
    synergy = {
      serviceConfig = {
        KeepAlive = true;
        Label = "com.synergy";
        ProgramArguments = [
          synergyClient.execPath
          "--name"
          vars.hostName
          "-f"
          vars.synergy.allowedServer
        ];
        RunAtLoad = true;
      };
    };
  };
}
