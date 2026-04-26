{ vars }:
{ path, content, mode ? "600" }:
{ lib, ... }:
{
  home.activation."writeFile_${builtins.replaceStrings [ "/" "." ] [ "_" "_" ] path}" =
    lib.hm.dag.entryAfter [ "writeBoundary" "agenix" ] ''
      mkdir -p ${dirOf path}
      echo "${content}" > ${path}
      chmod ${mode} ${path}
    '';
}
