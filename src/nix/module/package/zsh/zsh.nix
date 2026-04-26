{ pkgs, vars, ... }:
{
  home.file.".oh-my-zsh/custom/themes/handcraftedbits.zsh-theme".source = ./handcraftedbits.zsh-theme;

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ./initExtra.sh;

    oh-my-zsh = {
      custom = "$HOME/.oh-my-zsh/custom";
      enable = true;
      plugins = [
        "git"
        "podman"
        "shrink-path"
        "systemd"
      ];
      theme = "handcraftedbits";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          hash = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.1";
        };
      }
      {
        name = "zsh-256color";
        src = pkgs.fetchFromGitHub {
          hash = "sha256-P/pbpDJmsMSZkNi5GjVTDy7R+OxaIVZhb/bEnYQlaLo=";
          owner = "chrissicool";
          repo = "zsh-256color";
          rev = "559fee48bb74b75cec8b9887f8f3e046f01d5d8f";
        };
      }
    ];

    sessionVariables = {
      TERM = "xterm-256color";
    };

    shellAliases = {
      age-decrypt = "sudo age -d -i /etc/age-key";
      age-encrypt = "sudo age -e -a -i /etc/age-key";
      ls = "ls --color=tty -F";
      nix-rebuild = "sudo nixos-rebuild switch --flake /opt/config/src/nix#${vars.hostName} --impure";
    };
  };
}
