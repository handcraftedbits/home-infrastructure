{ vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  # Imports.
  imports = [
    ../../../module/core/linux.vm.nix

    # Mounts.
    (util.mkNfsMount {
      localPath = "/mnt/container";
      remotePath = "/mnt/vault02/container_dbhost_vm_lan_howard_estate";
    })
  ];

  # Quadlets
  home-manager.users.${vars.user.username}.imports = [
    (util.mkUserQuadlets {
      containers = [
        { directory = ./container/postgresql; }
        { directory = ./container/traefik; }
      ];
    })
  ];
}
