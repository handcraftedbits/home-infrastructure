{ pkgs, lib, config, vars, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  xdg.configFile."zsh/oh-my-zsh/custom/themes/handcraftedbits.zsh-theme".source = ./handcraftedbits.zsh-theme;

  programs.zsh = {
    completionInit = "autoload -U compinit && compinit -i -d ${config.xdg.cacheHome}/zsh/zcompdump";
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.dataHome}/zsh/history";
    initContent = if isLinux then builtins.readFile ./initExtra.sh else "";

    oh-my-zsh = {
      custom = "${config.xdg.configHome}/zsh/oh-my-zsh/custom";
      enable = true;
      plugins = [
        "git"
        "shrink-path"
      ] ++ (if isLinux then [ "podman" "systemd" ] else [ "docker" ]);
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
    ];

    sessionVariables = {
      SHELL_SESSIONS_DISABLE = "1";
      TERM = if isLinux then "xterm-256color" else "xterm-kitty";
      ZSH_COMPDUMP = "${config.xdg.cacheHome}/zsh/zcompdump";
      ZSH_DISABLE_COMPFIX = "true";
    };

    shellAliases = {
      age-decrypt = "sudo age -d -i /etc/age-key";
      age-encrypt = "sudo age -e -a -i /etc/age-key";
      ls = if isLinux then "ls --color=tty -F" else "ls -GF";
      nix-clean = "nix-collect-garbage -d";
      nix-rebuild = if isLinux
        then "sudo nixos-rebuild switch --flake /opt/config/src/nix#${vars.hostName} --impure"
        else "sudo darwin-rebuild switch --flake /opt/config/src/nix#${vars.hostName} --impure";
    };
  };

  home.activation.createZshDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.xdg.dataHome}/zsh ${config.xdg.cacheHome}/zsh
  '';
}
