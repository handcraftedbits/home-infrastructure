{ config, pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    nvtopPackages.nvidia
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    nvidia-container-toolkit.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Add required groups to the default user (primarily for Podman access).
  users.users.${vars.user.username}.extraGroups = [ "render" "video" ];
}
