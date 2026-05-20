{ ... }:
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      accordion-padding = 10;
      config-version = 2;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      gaps = {
        inner = {
          horizontal = 0;
          vertical = 0;
        };
        outer = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      mode.main.binding = {
        alt-0 = "balance-sizes";
        alt-ctrl-down = "join-with down";
        alt-ctrl-left = "join-with left";
        alt-ctrl-r = "flatten-workspace-tree";
        alt-ctrl-right = "join-with right";
        alt-ctrl-up = "join-with up";
        alt-down = "focus down";
        alt-left = "focus left";
        alt-minus = "resize width -50";
        alt-right = "focus right";
        alt-shift-down = "move down";
        alt-shift-equal = "resize width +50";
        alt-shift-left = "move left";
        alt-shift-right = "move right";
        alt-shift-up = "move up";
        alt-up = "focus up";
        ctrl-left = "workspace --wrap-around prev";
        ctrl-right = "workspace --wrap-around next";
      };

      start-at-login = true;
    };
  };
}
