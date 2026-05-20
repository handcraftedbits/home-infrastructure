{ vars, ... }:
{
  system.defaults.dock = {
    autohide = true;
    magnification = false;
    mru-spaces = false;
    orientation = "bottom";

    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/System/Applications/Utilities/Activity Monitor.app"
      "/System/Applications/App Store.app"
      "/System/Cryptexes/App/System/Applications/Safari.app"
      "/Applications/Nix Apps/Google Chrome.app"
      "/Applications/Nix Apps/kitty.app"
      "/Applications/Nix Apps/IntelliJ IDEA.app"
    ];

    persistent-others = [
      {
        folder = {
          path = "/Applications";
          displayas = "folder";
          showas = "grid";
        };
      }
      {
        folder = {
          path = "/Users/${vars.user.username}/Downloads";
          displayas = "folder";
          showas = "fan";
        };
      }
    ];

    show-recents = true;
    tilesize = 64;
  };
}
