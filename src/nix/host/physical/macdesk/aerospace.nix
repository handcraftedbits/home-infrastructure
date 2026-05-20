{ ... }:
{
  programs.aerospace.settings = {
    mode.main.binding = {
      alt-shift-1 = [ "move-node-to-workspace 1-default" "workspace 1-default" ];
      alt-shift-2 = [ "move-node-to-workspace 2-web" "workspace 2-web" ];
      alt-shift-3 = [ "move-node-to-workspace 3-terminal" "workspace 3-terminal" ];
      alt-shift-4 = [ "move-node-to-workspace 4-ide" "workspace 4-ide" ];
      ctrl-1 = "workspace 1-default";
      ctrl-2 = "workspace 2-web";
      ctrl-3 = "workspace 3-terminal";
      ctrl-4 = "workspace 4-ide";
    };

    on-window-detected = [
      {
        "if" = {
          app-id = "com.google.Chrome";
        };
        run = [
          "move-node-to-workspace 2-web"
        ];
      }
      {
        "if" = {
          app-id = "com.jetbrains.intellij";
        };
        run = [
          "move-node-to-workspace 4-ide"
          "layout h_accordion"
        ];
      }
    ];

    persistent-workspaces = [
      "1-default"
      "2-web"
      "3-terminal"
      "4-ide"
    ];
  };
}
