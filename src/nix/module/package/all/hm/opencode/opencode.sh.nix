{ config, containerRuntime }:
''
  mkdir -p ${config.xdg.cacheHome}/opencode
  mkdir -p ${config.xdg.configHome}/opencode
  mkdir -p ${config.xdg.configHome}/opencode/node_modules
  mkdir -p ${config.xdg.dataHome}/opencode

  touch ${config.xdg.configHome}/opencode/.gitignore
  touch ${config.xdg.configHome}/opencode/package.json
  touch ${config.xdg.configHome}/opencode/package-lock.json

  ${containerRuntime} run -it --rm \
    --env KITTY_WINDOW_ID="''${KITTY_WINDOW_ID}" \
    --hostname "$(hostname)" \
    --network=host \
    --volume "${config.xdg.cacheHome}/opencode":/root/.cache/opencode \
    --volume "${config.xdg.configHome}/opencode/.gitignore":/root/.config/opencode/.gitignore \
    --volume "${config.xdg.configHome}/opencode/package.json":/root/.config/opencode/package.json \
    --volume "${config.xdg.configHome}/opencode/package-lock.json":/root/.config/opencode/package-lock.json \
    --volume "$(realpath ${config.xdg.configHome}/opencode/agents)":/root/.config/opencode/agents \
    --volume "$(realpath ${config.xdg.configHome}/opencode/node_modules)":/root/.config/opencode/node_modules \
    --volume "$(realpath ${config.xdg.configHome}/opencode/skills)":/root/.config/opencode/skills \
    --volume "${config.xdg.dataHome}/opencode":/root/.local/share/opencode \
    --volume "$(realpath ${config.xdg.configHome}/opencode/opencode-default.json)":/root/.config/opencode/opencode.jsonc \
    --volume "$(realpath ${config.xdg.configHome}/opencode/tui.json)":/root/.config/opencode/tui.json \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    ghcr.io/handcraftedbits/opencode-runner "$@"
''
