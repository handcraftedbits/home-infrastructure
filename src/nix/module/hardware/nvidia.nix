{ config, pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    nvtopPackages.nvidia
  ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver { 
      openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8="; 
      persistencedSha256 = "sha256-AtjM/ml/ngZil8DMYNH+P111ohuk9mWw5t4z7CHjPWw=";
      settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c="; 
      sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk="; 
      usePersistenced = true;
      version = "595.58.03"; 
    };
  };
  hardware.nvidia-container-toolkit.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # Add required groups to the default user (primarily for Podman access).
  users.users.${vars.user.username}.extraGroups = [ "render" "video" ];
}