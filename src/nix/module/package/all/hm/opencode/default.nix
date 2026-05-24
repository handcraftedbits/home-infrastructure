{ pkgs, lib, config, ... }:
let
  containerRuntime = if pkgs.stdenv.isLinux then "podman" else "docker";
in
{
  xdg.configFile."opencode/opencode.jsonc".source = ./opencode.jsonc;

  home.packages = [
    (pkgs.writeShellScriptBin "opencode" (import ./opencode.sh.nix { inherit config containerRuntime; }))
    (pkgs.writeShellScriptBin "opencode-acp" (import ./opencode_acp.sh.nix { inherit config containerRuntime; }))
  ];
}
