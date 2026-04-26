{ pkgs, ... }:
{
  systemd.user.services.unison-sync = {
    after = [ "network.target" ];
    description = "Perform initial sync of /opt/container from /mnt/container";
    serviceConfig = {
      ExecStart = "${pkgs.writeShellScript "unison-sync" ''
        if [ -z "$(${pkgs.coreutils}/bin/ls -A $HOME/.local/share/container 2>/dev/null)" ]
        then
          ${pkgs.unison}/bin/unison \
            $HOME/.local/share/container \
            /mnt/container \
            -auto \
            -batch \
            -ignorearchives \
            -log \
            -logfile $HOME/.local/state/unison-sync.log \
            -prefer /mnt/container
        fi
      ''}";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p %h/.local/state"
        "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/container"
      ];
      RemainAfterExit = true;
      Type = "oneshot";
    };
    unitConfig = {
      RequiresMountsFor = "/mnt/container";
    };
    wantedBy = [ "default.target" ];
    wants = [ "mnt-container.mount" ];
  };
}
