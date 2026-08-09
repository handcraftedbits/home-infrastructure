{ vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  imports = [
    ../../../module/os/linux/internal/vm.nix
    util.mkDefaultMounts

    (util.mkNfsMount {
      localPath = "/mnt/container";
      remotePath = "/mnt/vault02/container_datahost_vm_lan_howard_estate";
    })
  ];

  # Quadlets
  home-manager.users.${vars.user.username}.imports = [
    (util.mkUserQuadlets {
      containers = [
        { directory = ./container/postgresql; }
        { directory = ./container/silo; }
        { directory = ./container/traefik; }
      ];
    })
  ];
}
