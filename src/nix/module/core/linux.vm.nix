{ vars, ... }:
let
  util = import ../util { inherit vars; };
in
{
  imports = [
    ./linux.nix

    (util.mkCifsMount {
      credentialsFile = ../secret/samba/credentials.age;
      localPath = "/mnt/family";
      remotePath = "/family";
    })
    (util.mkCifsMount {
      credentialsFile = ../secret/samba/credentials.age;
      localPath = "/mnt/media";
      remotePath = "/media";
    })
    (util.mkCifsMount {
      credentialsFile = ../secret/samba/credentials.age;
      localPath = "/mnt/software";
      remotePath = "/software";
    })
  ];

  virtualisation.vmware.guest.enable = true;
}
