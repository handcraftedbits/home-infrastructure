# Hash secrets together to force HM to regenerate if a secret is updated.
{ lib }:
let
  inherit (builtins) filter hashFile hashString map;
  inherit (lib) concatStringsSep hasSuffix;
  inherit (lib.filesystem) listFilesRecursive;

  ageFiles = filter (file: hasSuffix ".age" (baseNameOf file)) (listFilesRecursive ../secret);
in
hashString "sha256" (concatStringsSep "" (map (file: hashFile "sha256" file) ageFiles))
