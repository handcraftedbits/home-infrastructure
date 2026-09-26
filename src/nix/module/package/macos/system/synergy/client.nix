{ config, pkgs, vars, ... }:
let
  # Run from the stable copy nix-darwin makes, not from the store, so the bundle is easy to find in System Settings.
  execPath = "/Applications/Nix Apps/Synergy Client.app/Contents/MacOS/Synergy Client";

  # A bundle with a stable identity, so that the Accessibility grant survives rebuilds; see README.md.
  synergyClient = config.lib.appIdentity.mkAppBundle {
    executable = "${pkgs.synergy}/bin/.synergyc-wrapped";
    identifier = "com.curtisshoward.synergyc";
    mainProgram = "synergyc";
    name = "Synergy Client";
  };
in
{
  environment.systemPackages = [
    synergyClient
  ];

  launchd.user.agents = {
    synergy = {
      serviceConfig = {
        KeepAlive = true;
        Label = "com.synergy";
        ProgramArguments = [
          execPath
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
