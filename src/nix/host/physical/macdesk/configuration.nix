{ pkgs, vars, ... }:
{
  imports = [
    ./dock.nix
    ../../../module/os/macos
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./aerospace.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    audacity
    ffmpeg
    mkvtoolnix
    yt-dlp
  ];

  homebrew.casks = [
    "eqmac"
    "gimp"
    "inkscape"
    "mp3tag"
    "tinymediamanager"
    "xnviewmp"
  ];
}
