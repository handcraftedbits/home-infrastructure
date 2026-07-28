{ config, lib, pkgs, ... }:
let
  configDirs = [
    "agents"
    "skills"
  ];

  containerRuntime = if pkgs.stdenv.isLinux then "podman" else "docker";

  linkedDirs = lib.foldl' (acc: subdir:
    let path = ./. + "/${subdir}"; in
    acc // lib.optionalAttrs (builtins.pathExists path) {
      "opencode/${subdir}".source = path;
    }) {} configDirs;

  opencodeConfigBase = builtins.fromJSON (builtins.readFile ./config/opencode.json);
  opencodeConfigDefault = builtins.fromJSON (builtins.readFile ./config/patch-default.json);
  opencodeConfigIntellij = builtins.fromJSON (builtins.readFile ./config/patch-intellij.json);

  toJson = (pkgs.formats.json {}).generate;
in
{
  xdg.configFile= {
    "opencode/opencode-default.json".source  = toJson "opencode-default.json"
      (lib.recursiveUpdate opencodeConfigBase opencodeConfigDefault);
    "opencode/opencode-intellij.json".source = toJson "opencode-intellij.json"
      (lib.recursiveUpdate opencodeConfigBase opencodeConfigIntellij);
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
