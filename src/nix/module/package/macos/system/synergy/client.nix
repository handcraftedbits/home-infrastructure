{ pkgs, vars, ... }:
{
  launchd.user.agents = {
    synergy = {
      serviceConfig = {
        KeepAlive = true;
        Label = "com.synergy";
        ProgramArguments = [ "/usr/local/bin/synergyc" "--name" vars.hostName "-f" vars.synergy.allowedServer ];
        RunAtLoad = true;
      };
    };
  };

  system.activationScripts.postActivation.text = ''
    ln -sf ${pkgs.synergy}/bin/synergyc /usr/local/bin/synergyc
  '';
}
