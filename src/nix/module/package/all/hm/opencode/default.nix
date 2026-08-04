{ config, lib, pkgs, ... }:
let
  agents = import ./agents { inherit lib pkgs; };

  configDirs = [
    "skills"
  ];

  containerRuntime = if pkgs.stdenv.isLinux then "podman" else "docker";

  linkedDirs = lib.foldl' (acc: subdir:
    let path = ./. + "/${subdir}"; in
    acc // lib.optionalAttrs (builtins.pathExists path) {
      "opencode/${subdir}".source = path;
    }) {} configDirs;

  opencodeConfig = profile: patch: toJson "opencode-${profile}.json" (lib.recursiveUpdate
    (lib.recursiveUpdate opencodeConfigBase { agent = agents.${profile}.settings; })
    (lib.optionalAttrs (builtins.pathExists patch) (builtins.fromJSON (builtins.readFile patch))));

  opencodeConfigBase = builtins.fromJSON (builtins.readFile ./config/opencode.json);

  toJson = (pkgs.formats.json {}).generate;
in
{
  xdg.configFile= {
    "opencode/opencode-default.json".source  = opencodeConfig "default" ./config/patch-default.json;
    "opencode/opencode-intellij.json".source = opencodeConfig "intellij" ./config/patch-intellij.json;
    "opencode/agents-default".source  = agents.default.directory;
    "opencode/agents-intellij".source = agents.intellij.directory;
    "opencode/tui.json" = {
      text = builtins.toJSON {
        theme = "monokai";
      };
    };
  } // linkedDirs;

  home.packages = [
    (pkgs.writeShellScriptBin "opencode" (import ./opencode.sh.nix { inherit config containerRuntime; }))
  ] ++ lib.optionals (!pkgs.stdenv.isLinux) [
    (pkgs.writeShellScriptBin "opencode-intellij"
      (import ./opencode_intellij.sh.nix { inherit config containerRuntime; }))
  ];
}
