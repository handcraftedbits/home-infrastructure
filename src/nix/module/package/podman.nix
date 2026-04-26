{
  systemd.user.timers.podman-auto-update = {
    enable = true;
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };
}
