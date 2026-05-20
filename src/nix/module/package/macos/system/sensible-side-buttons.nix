{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sensible-side-buttons
  ];

  launchd.user.agents = {
    sensible-side-buttons = {
      serviceConfig = {
        Label = "com.sensible-side-buttons";
        ProgramArguments = [ "${pkgs.sensible-side-buttons}/Applications/SensibleSideButtons.app/Contents/MacOS/SensibleSideButtons" ];
        RunAtLoad = true;
      };
    };
  };
}
