{ config, containerRuntime }:
''
  ${containerRuntime} run -i --rm \
    --hostname "$(hostname)" \
    --volume ${config.xdg.cacheHome}/opencode:/root/.cache/opencode \
    --volume ${config.xdg.configHome}/opencode:/root/.config/opencode \
    --volume ${config.xdg.dataHome}/opencode:/root/.local/share/opencode \
    --volume "$(realpath ${config.xdg.configHome}/opencode/opencode.jsonc)":/root/.config/opencode/opencode.jsonc \
    --volume "''${PROJECT_DIR:-$(pwd)}:''${PROJECT_DIR:-$(pwd)}" \
    --workdir "''${PROJECT_DIR:-$(pwd)}" \
    ghcr.io/handcraftedbits/opencode-runner acp
''
