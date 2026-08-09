{ name, host, port }:
{ pkgs, ... }:
let
  script = pkgs.writeShellScript "${name}-check" ''
    until ${pkgs.netcat-openbsd}/bin/nc -z ${host} ${toString port}; do
      ${pkgs.coreutils}/bin/sleep 2
    done

    ${pkgs.systemd}/bin/systemd-notify --ready

    while ${pkgs.netcat-openbsd}/bin/nc -z ${host} ${toString port}; do
      ${pkgs.coreutils}/bin/sleep 5
    done

    exit 1
  '';
in
{
  systemd.user.services.${name} = {
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = "${script}";
      NotifyAccess = "all";
      Restart = "always";
      RestartSec = 2;
      Type = "notify";
    };

    Unit.Description = "TCP Availability (${host}:${toString port})";
  };
}