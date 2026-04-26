{ pkgs, ... }:
{
  systemd.user.services.unison-watch = {
    after = [ "unison-sync.service" ];
    description = "Watch /opt/container and sync to /mnt/container";
    requires = [ "unison-sync.service" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.unison}/bin/unison \
          %h/.local/share/container \
          /mnt/container \
          -auto \
          -batch \
          -log \
          -logfile %h/.local/state/unison-watch.log \
          -prefer %h/.local/share/container \
          -repeat watch
      '';
      Restart = "on-failure";
      RestartSec = 30;
      Type = "simple";
    };
    unitConfig = {
      StartLimitIntervalSec = 0;
    };
    wantedBy = [ "default.target" ];
  };
}
