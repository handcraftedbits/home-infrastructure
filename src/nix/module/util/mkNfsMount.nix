{ vars }:
{ localPath, remotePath }:
{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems.${localPath} = {
    device = "${vars.nfs.server}:${remotePath}";
    fsType = "nfs";
    options = [
      "hard"
      "nconnect=16"
      "noatime"
      "proto=tcp"
      "retrans=2"
      "rw"
      "suid"
      "timeo=600"
      "vers=4.2"
      "x-systemd.automount"
      "_netdev"
    ];
  };
}
