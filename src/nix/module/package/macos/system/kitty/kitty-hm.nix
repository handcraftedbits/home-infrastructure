{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family family="SauceCodePro Nerd Font" style="Medium"
    '';

    font = {
      name = "SauceCodePro Nerd Font";
      size = 12.0;
    };

    keybindings = {
      "ctrl+a>c" = "new_tab";
      "ctrl+a>n" = "next_tab";
      "ctrl+a>p" = "previous_tab";
      "ctrl+a>x" = "close_tab";
      "ctrl+a>," = "set_tab_title";
      "ctrl+a>." = "set_tab_title \"\"";
      "ctrl+a>0" = "goto_tab 1";
      "ctrl+a>1" = "goto_tab 2";
      "ctrl+a>2" = "goto_tab 3";
      "ctrl+a>3" = "goto_tab 4";
      "ctrl+a>4" = "goto_tab 5";
      "ctrl+a>5" = "goto_tab 6";
      "ctrl+a>6" = "goto_tab 7";
      "ctrl+a>7" = "goto_tab 8";
      "ctrl+a>8" = "goto_tab 9";
      "ctrl+a>9" = "goto_tab 10";
    };

    package = null;

    settings = {
      allow_remote_control = "yes";
      active_tab_background = "#D5D3A0";
      active_tab_foreground = "#2D3340";
      active_tab_title_template = "{index}";
      inactive_tab_background = "#5A7A9A";
      inactive_tab_foreground = "#D5D3A0";
      single_instance = false;
      tab_activity_symbol = "none";
      tab_bar_align = "left";
      tab_bar_background = "#5A7A9A";
      tab_bar_edge = "bottom";
      tab_bar_min_tabs = 1;
      tab_bar_style = "custom";
      tab_title_template = "{index}";
    };
  };

  programs.zsh.shellAliases = {
    ssh = "kitten ssh -o ControlMaster=no -o ControlPath=none";
  };

  xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;
}
