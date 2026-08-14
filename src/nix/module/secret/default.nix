{ lib, vars, ... }:
let
  # Excluded since these secrets have special handling.
  excludedDirs = [
    "samba"
    "wireguard"
  ];

  ageFiles = builtins.filter
    (file:
      lib.hasSuffix ".age" (baseNameOf file)
      && !(lib.any (dir: lib.hasPrefix (toString (./. + "/${dir}")) (toString file)) excludedDirs))
    (lib.filesystem.listFilesRecursive ./.);

  mkSecret = file:
    let
      name = toName file;
    in
    {
      inherit name;
      value = {
        inherit file;
        mode = if lib.hasSuffix "privateKey" name then "0600" else "0400";
        owner = vars.user.username;
      };
    };

  toName = file:
    lib.removeSuffix ".age" (lib.removePrefix (toString ./. + "/") (toString file));
in
{
  age = {
    identityPaths = [ "/etc/age-key" ];
    secrets = builtins.listToAttrs (map mkSecret ageFiles);
  };
}
