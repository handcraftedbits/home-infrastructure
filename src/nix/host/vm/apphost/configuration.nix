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
      remotePath = "/mnt/vault02/container_apphost_vm_lan_howard_estate";
    })
  ];

  # Quadlets
  home-manager.users.${vars.user.username}.imports = [
    (util.mkUserQuadlets {
      containers = [
        { directory = ./container/forgejo; }
        { directory = ./container/glance; }
        {
          directory = ./container/immich-server;
          enabled = false;
        }
        {
          directory = ./container/immich-valkey;
          enabled = false;
        }
        { directory = ./container/jellyfin; }
        { directory = ./container/linkwarden; }
        { directory = ./container/mermaid; }
        { directory = ./container/navidrome; }
        { directory = ./container/openwebui; }
        { directory = ./container/silverbullet; }
        { directory = ./container/traefik; }
        { directory = ./container/vaultwarden; }
      ];
    })
  ];
}
