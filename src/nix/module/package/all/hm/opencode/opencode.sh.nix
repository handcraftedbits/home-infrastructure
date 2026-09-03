{ config, containerRuntime }:
''
  mkdir -p "''${HOME}/.m2"
  mkdir -p ${config.xdg.cacheHome}/opencode
  mkdir -p ${config.xdg.configHome}/opencode
  mkdir -p ${config.xdg.configHome}/opencode/node_modules
  mkdir -p ${config.xdg.dataHome}/opencode
  mkdir -p ${config.xdg.stateHome}/opencode

  touch ${config.xdg.configHome}/opencode/.gitignore

  if [ ! -s ${config.xdg.configHome}/opencode/package.json ]
  then
    echo "{}" > ${config.xdg.configHome}/opencode/package.json
  fi

  if [ ! -s ${config.xdg.configHome}/opencode/package-lock.json ]
  then
    echo "{}" > ${config.xdg.configHome}/opencode/package-lock.json
  fi

  ${containerRuntime} run -it --rm \
    --env KITTY_WINDOW_ID="''${KITTY_WINDOW_ID}" \
    --env PTY_WEB_HOSTNAME=0.0.0.0 \
    --env PTY_WEB_PORT=58213 \
    --hostname "$(hostname)" \
    --network=host \
    --volume "''${HOME}/.m2":/root/.m2 \
    --volume "${config.xdg.cacheHome}/opencode":/root/.cache/opencode \
    --volume "${config.xdg.configHome}/opencode/.gitignore":/root/.config/opencode/.gitignore \
    --volume "$(realpath ${config.xdg.configHome}/opencode/agents-default)":/root/.config/opencode/agents \
    --volume "$(realpath ${config.xdg.configHome}/opencode/node_modules)":/root/.config/opencode/node_modules \
    --volume "$(realpath ${config.xdg.configHome}/opencode/opencode-default.json)":/root/.config/opencode/opencode.json \
    --volume "${config.xdg.configHome}/opencode/package.json":/root/.config/opencode/package.json \
    --volume "${config.xdg.configHome}/opencode/package-lock.json":/root/.config/opencode/package-lock.json \
    --volume "$(realpath ${config.xdg.configHome}/opencode/skills)":/root/.config/opencode/skills \
    --volume "$(realpath ${config.xdg.configHome}/opencode/tui.json)":/root/.config/opencode/tui.json \
    --volume "${config.xdg.dataHome}/opencode":/root/.local/share/opencode \
    --volume "${config.xdg.stateHome}/opencode":/root/.local/state/opencode \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    ghcr.io/handcraftedbits/opencode-runner "$@"
''
