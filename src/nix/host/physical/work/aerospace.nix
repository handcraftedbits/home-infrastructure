{ ... }:
{
  programs.aerospace.settings = {
    mode.main.binding = {
      alt-shift-1 = [ "move-node-to-workspace 1-default" "workspace 1-default" ];
      alt-shift-2 = [ "move-node-to-workspace 2-office" "workspace 2-office" ];
      alt-shift-3 = [ "move-node-to-workspace 3-web" "workspace 3-web" ];
      alt-shift-4 = [ "move-node-to-workspace 4-terminal" "workspace 4-terminal" ];
      alt-shift-5 = [ "move-node-to-workspace 4-ide" "workspace 5-ide" ];
      ctrl-1 = "workspace 1-default";
      ctrl-2 = "workspace 2-office";
      ctrl-3 = "workspace 3-web";
      ctrl-4 = "workspace 4-terminal";
      ctrl-5 = "workspace 5-ide";
    };

    on-window-detected = [
      {
        "if" = {
          app-id = "com.microsoft.Outlook";
        };
        run = [
          "move-node-to-workspace 2-office"
        ];
      }
      {
        "if" = {
          app-id = "com.tinyspeck.slackmacgap";
        };
        run = [
          "move-node-to-workspace 2-office"
        ];
      }
      {
        "if" = {
          app-id = "com.google.Chrome";
        };
        run = [
          "move-node-to-workspace 3-web"
        ];
      }
      {
        "if" = {
          app-id = "com.jetbrains.intellij";
        };
        run = [
          "move-node-to-workspace 5-ide"
          "layout h_accordion"
        ];
      }
    ];

    persistent-workspaces = [
      "1-default"
      "2-office"
      "3-web"
      "4-terminal"
      "5-ide"
    ];
  };
}
