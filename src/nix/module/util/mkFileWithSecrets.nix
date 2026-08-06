{ vars }:
{ path, content, mode ? "600" }:
{ lib, ... }:
let
  secretsHash = import ./secretsHash.nix { inherit lib; };
in
{
  home.activation."writeFile_${builtins.replaceStrings [ "/" "." ] [ "_" "_" ] path}" =
    lib.hm.dag.entryAfter [ "writeBoundary" "agenix" ] ''
      # secrets: ${secretsHash}
      mkdir -p ${dirOf path}
      echo "${content}" > ${path}
      chmod ${mode} ${path}
    '';
}
