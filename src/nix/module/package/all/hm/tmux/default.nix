{ config, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ./tmux.conf}
      source-file ${config.xdg.configHome}/tmux/molokai.conf
    '';
  };

  xdg.configFile."tmux/molokai.conf".source = ./molokai.conf;
}
