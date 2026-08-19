{ pkgs, vars, ... }:
{
  imports = [
    ./dock.nix
    ../../../module/os/macos
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./aerospace.nix
      ./gnupg.nix
      ./maven.nix
    ];
  };

  # Secrets
  age.secrets = {
    "gpg/privateKey" = {
      file = ../../../module/secret/gpg/privateKey.age;
      mode = "0600";
      owner = vars.user.username;
    };
    "sonatype/password" = {
      file = ../../../module/secret/sonatype/password.age;
      mode = "0400";
      owner = vars.user.username;
    };
    "sonatype/username" = {
      file = ../../../module/secret/sonatype/username.age;
      mode = "0400";
      owner = vars.user.username;
    };
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
