{ index }:
{ pkgs, ... }:
let
  name = "nvidia-gpu-${toString index}-available";

  script = pkgs.writeShellScript "${name}-check" ''
    until [ -e /dev/nvidia${toString index} ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do
      ${pkgs.coreutils}/bin/sleep 2
    done
  '';
in
{
  systemd.user.services.${name} = {
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = "${script}";
      RemainAfterExit = true;
      Type = "oneshot";
    };

    Unit.Description = "NVIDIA GPU ${toString index} Availability";
  };
}