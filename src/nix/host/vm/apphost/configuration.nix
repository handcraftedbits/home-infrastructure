{ vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  imports = [
    ../../../module/os/linux/internal/vm.nix
    util.mkDefaultMounts

    # Mounts
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
        { directory = ./container/openai-transcription-normalizer; }
        { directory = ./container/openchamber; }
        { directory = ./container/romm; }
        { directory = ./container/searxng; }
        { directory = ./container/silverbullet; }
        { directory = ./container/traefik; }
        { directory = ./container/vaultwarden; }
      ];
    })
    (util.mkTcpAvailabilityService {
      name = "audio-cpp-available";
      host = "audiocpp.app.howard.estate";
      port = 443;
    })
    (util.mkTcpAvailabilityService {
      name = "immich-machine-learning-available";
      host = "aihost.vm.lan.howard.estate";
      port = 3003;
    })
    (util.mkTcpAvailabilityService {
      name = "litellm-available";
      host = "llm.howard.estate";
      port = 443;
    })
    (util.mkTcpAvailabilityService {
      name = "postgresql-available";
      host = "postgresql.db.howard.estate";
      port = 5432;
    })
    ({ config, lib, ... }: {
      home.activation.opencodeBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.home.homeDirectory}/.cache/opencode
        mkdir -p ${config.home.homeDirectory}/.config/opencode/node_modules
        mkdir -p ${config.home.homeDirectory}/.local/share/opencode
        mkdir -p ${config.home.homeDirectory}/.local/state/opencode

        touch ${config.home.homeDirectory}/.config/opencode/.gitignore

        if [ ! -s ${config.home.homeDirectory}/.config/opencode/package.json ]; then
          echo "{}" > ${config.home.homeDirectory}/.config/opencode/package.json
        fi

        if [ ! -s ${config.home.homeDirectory}/.config/opencode/package-lock.json ]; then
          echo "{}" > ${config.home.homeDirectory}/.config/opencode/package-lock.json
        fi
      '';
    })
  ];
}
