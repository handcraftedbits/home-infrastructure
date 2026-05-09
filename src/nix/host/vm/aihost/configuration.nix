{ vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  # Imports.
  imports = [
    ../../../module/core/linux.vm.nix
    ../../../module/hardware/nvidia.nix

    # Mounts.
    (util.mkNfsMount {
      localPath = "/mnt/container";
      remotePath = "/mnt/vault02/container_aihost_vm_lan_howard_estate";
    })
  ];

  # Quadlets
  home-manager.users.${vars.user.username}.imports = [
    (util.mkUserQuadlets {
      containers = [
        { directory = ./container/aitoolkit; }
        {
          directory = ./container/comfyui;
          enabled = false;
        }
        { directory = ./container/immich-machine-learning; }
        { directory = ./container/traefik; }
        { directory = ./container/vllm-coding-agent; }
      ];
    })
  ];
}
