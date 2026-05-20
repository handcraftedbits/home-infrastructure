{ pkgs, vars, ... }:
{
  environment.etc."synergy/synergy.conf".text = import ./synergy.conf.nix { inherit vars; };

  launchd.user.agents = {
    synergy = {
      serviceConfig = {
        KeepAlive = true;
        Label = "com.synergy";
        ProgramArguments = [ "/usr/local/bin/synergys" "-c" "/etc/synergy/synergy.conf" "-f" ];
        RunAtLoad = true;
      };
    };
  };

  system.activationScripts.postActivation.text = ''
    ln -sf ${pkgs.synergy}/bin/synergys /usr/local/bin/synergys
  '';
}