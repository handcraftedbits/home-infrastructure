{ vars }:
let
  credentialsFile = ../../secret/samba/credentials.age;
  mkCifsMount = import ../mkCifsMount.nix { inherit vars; };
in
{ lib, pkgs, system, ... }:
let
  isLinux = lib.hasSuffix "-linux" system;
in
{
  imports = lib.optionals isLinux [
    (mkCifsMount {
      inherit credentialsFile;

      localPath = "/mnt/family";
      remotePath = "/family";
    })
    (mkCifsMount {
      inherit credentialsFile;

      localPath = "/mnt/media";
      remotePath = "/media";
    })
    (mkCifsMount {
      inherit credentialsFile;

      localPath = "/mnt/software";
      remotePath = "/software";
    })
  ];
} // lib.optionalAttrs (!isLinux) {
  home-manager.users.${vars.user.username} = { ... }: {
    launchd.agents."mount-smb" = {
      enable = true;
      config = {
        KeepAlive = false;
        Label = "local.mount-smb";
        ProgramArguments = [
          (toString (pkgs.writeShellScript "mount-smb" (import ./mount-smb.nix { inherit pkgs vars; })))
        ];
        RunAtLoad = true;
      };
    };
  };
}
