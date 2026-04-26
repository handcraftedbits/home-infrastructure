{ vars }:
{ localPath, remotePath, credentialsFile }:
let
  credentialsPath = "/etc/samba/credentials.${builtins.replaceStrings [ "/" ] [ "_" ] localPath}";
in
{
  boot.supportedFilesystems = [ "cifs" ];

  age.secrets."samba_credentials${builtins.replaceStrings [ "/" ] [ "_" ] localPath}" = {
    file = credentialsFile;
    path = credentialsPath;
    mode = "0400";
  };

  fileSystems.${localPath} = {
    device = "//${vars.cifs.server}${remotePath}";
    fsType = "cifs";
    options = [
      "credentials=${credentialsPath}"
      "uid=${toString (vars.user.uid or 1000)}"
      "gid=${toString (vars.user.gid or 1000)}"
      "file_mode=0660"
      "dir_mode=0770"
      "_netdev"
    ];
  };
}
