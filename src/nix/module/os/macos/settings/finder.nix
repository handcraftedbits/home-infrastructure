{ ... }:
{
  system.defaults = {
    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.finder" = {
        DesktopViewSettings = {
          IconViewSettings = {
            arrangeBy = "name";
            gridSpacing = 54;
            iconSize = 64;
            showItemInfo = false;
          };
        };
      };
    };

    finder = {
      _FXSortFoldersFirst = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = true;
      ShowStatusBar = true;
    };
  };
}
