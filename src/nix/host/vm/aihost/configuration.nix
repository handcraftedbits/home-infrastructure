{ pkgs, vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  environment.systemPackages = with pkgs; [
    cudaPackages_13_2.cuda_nvcc
    cudaPackages_13_2.cuda_cudart
    python3
    python3Packages.huggingface-hub
    python3Packages.pip
    uv
  ];

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
        { directory = ./container/immich-machine-learning; }
        { directory = ./container/jina; }
        { directory = ./container/labelstudio; }
        { directory = ./container/labelstudio-ml-backend; }
        { directory = ./container/litellm; }
        { directory = ./container/llama-task-model; }
        { directory = ./container/mcp-jina; }
        { directory = ./container/mcp-searxng; }
        { directory = ./container/mcphub; }
        { directory = ./container/tei-embedding-model; }
        { directory = ./container/traefik; }
        { directory = ./container/vllm-coding-model; }
      ];
    })
    (util.mkGpuAvailabilityService { index = 0; })
    (util.mkGpuAvailabilityService { index = 1; })
    (util.mkTcpAvailabilityService {
      name = "postgresql-available";
      host = "postgresql.db.howard.estate";
      port = 5432;
    })
    (util.mkTcpAvailabilityService {
      name = "searxng-available";
      host = "searxng.app.howard.estate";
      port = 443;
    })
  ];
}
