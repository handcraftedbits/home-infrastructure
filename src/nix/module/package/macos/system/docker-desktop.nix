{ ... }:
{
  homebrew.casks = [
    "docker-desktop"
  ];

  launchd.user.agents = {
    docker-desktop = {
      serviceConfig = {
        Label = "com.docker";
        ProgramArguments = [ "/Applications/Docker.app/Contents/MacOS/Docker\ Desktop.app/Contents/MacOS/Docker\ Desktop" ];
        RunAtLoad = true;
      };
    };
  };
}
