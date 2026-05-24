{ config, containerRuntime }:
''
  ${containerRuntime} run -it --rm \
    --env KITTY_WINDOW_ID="''${KITTY_WINDOW_ID}" \
    --hostname "$(hostname)" \
    --volume ${config.xdg.cacheHome}/opencode:/root/.cache/opencode \
    --volume ${config.xdg.configHome}/opencode:/root/.config/opencode \
    --volume ${config.xdg.dataHome}/opencode:/root/.local/share/opencode \
    --volume "$(realpath ${config.xdg.configHome}/opencode/opencode.jsonc)":/root/.config/opencode/opencode.jsonc \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    ghcr.io/handcraftedbits/opencode-runner "$@"
''
