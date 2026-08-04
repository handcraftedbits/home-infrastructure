{ config, containerRuntime }:
''
  port=""

  usage() {
    echo "Usage: opencode-intellij -p <port>"
    echo ""
    echo "  -p <port>  AgentBridge port (required)"
    echo "  -h         Show this help message"
  }

  if ! args=$(getopt hp: "$@")
  then
    usage >&2

    exit 1
  fi

  set -- $args

  while true
  do
    case "$1" in
      -h) usage; exit 0 ;;
      -p)
        PORT="$2"; shift; shift ;;
      --) shift; break ;;
    esac
  done

  if [ -z "$PORT" ]
  then
    echo "Error: AgentBridge port is required" >&2
    usage >&2

    exit 1
  fi

  mkdir -p /tmp/opencode-intellij
  sed 's/''${agent_bridge_port}/'"$PORT"'/g' "${config.xdg.configHome}/opencode/opencode-intellij.json" \
    > /tmp/opencode-intellij/opencode.jsonc

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
    --hostname "$(hostname)" \
    --network=host \
    --volume "${config.xdg.cacheHome}/opencode":/root/.cache/opencode \
    --volume "${config.xdg.configHome}/opencode/.gitignore":/root/.config/opencode/.gitignore \
    --volume "$(realpath ${config.xdg.configHome}/opencode/agents)":/root/.config/opencode/agents \
    --volume "$(realpath ${config.xdg.configHome}/opencode/node_modules)":/root/.config/opencode/node_modules \
    --volume "/tmp/opencode-intellij/opencode.jsonc":/root/.config/opencode/opencode.json \
    --volume "${config.xdg.configHome}/opencode/package.json":/root/.config/opencode/package.json \
    --volume "${config.xdg.configHome}/opencode/package-lock.json":/root/.config/opencode/package-lock.json \
    --volume "$(realpath ${config.xdg.configHome}/opencode/skills)":/root/.config/opencode/skills \
    --volume "$(realpath ${config.xdg.configHome}/opencode/tui.json)":/root/.config/opencode/tui.json \
    --volume "${config.xdg.dataHome}/opencode":/root/.local/share/opencode \
    --volume "${config.xdg.stateHome}/opencode":/root/.local/state/opencode \
    --volume "''${PROJECT_DIR:-$(pwd)}:''${PROJECT_DIR:-$(pwd)}" \
    --workdir "''${PROJECT_DIR:-$(pwd)}" \
    ghcr.io/handcraftedbits/opencode-runner "$@"
''
