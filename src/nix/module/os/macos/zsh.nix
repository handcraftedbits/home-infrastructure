{ pkgs, system, vars, ... }:
{
  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ../../package/all/hm/zsh
    ];
  };

  home-manager.users.root = { ... }: {
    imports = [
      ../../package/all/hm/zsh
    ];
    home.stateVersion = vars.nixosVersion;
  };

  environment.shells = with pkgs; [
    zsh
  ];

  users.users.root.home = "/var/root";

  programs.zsh.enableCompletion = false;
  programs.zsh.shellInit = ''
    autoload -U bashcompinit && bashcompinit
  '';

  system.activationScripts.postActivation.text = ''
    /usr/bin/dscl . -create /Users/${vars.user.username} UserShell /run/current-system/sw/bin/zsh
    /usr/bin/chsh -s /run/current-system/sw/bin/zsh root
  '';
}
