{ vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  imports = [
    ../../../module/hardware/nvidia.nix
    ../../../module/os/linux/internal/vm.nix
    util.mkDefaultMounts

    # Mounts
    (util.mkNfsMount {
      localPath = "/mnt/container";
      remotePath = "/mnt/vault02/container_aihost_vm_lan_howard_estate";
    })
  ];

  # Quadlets
  home-manager.users.${vars.user.username}.imports = [
    (util.mkUserQuadlets {
      containers = [
        { directory = ./container/audio-cpp; }
        { directory = ./container/aitoolkit; }
        { directory = ./container/comfyui; }
        { directory = ./container/docsgpt-valkey; }
        { directory = ./container/docsgpt-api; }
        { directory = ./container/docsgpt-worker; }
        { directory = ./container/immich-machine-learning; }
        { directory = ./container/jina; }
        { directory = ./container/labelstudio; }
        { directory = ./container/labelstudio-ml-backend; }
        { directory = ./container/llama-task-agent; }
        { directory = ./container/mcp-jina; }
        { directory = ./container/mcp-searxng; }
        { directory = ./container/mcphub; }
        { directory = ./container/tei-embedding-model; }
        { directory = ./container/traefik; }
        { directory = ./container/vllm-coding-agent; }
      ];
    })
  ];
}
