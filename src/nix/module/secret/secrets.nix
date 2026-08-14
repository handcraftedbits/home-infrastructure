let
  age-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnm6N2Wlqj8nhjUoboYmApjkgBnEBiuSHYzXlx9q/HZ";

  # Create secret definitions from all *.age files, matched recursively.
  findAgeFiles = dir: prefix:
    builtins.concatMap
      (name:
        let
          relName = if prefix == "" then name else "${prefix}/${name}";
        in
        if (builtins.readDir dir).${name} == "directory"
        then findAgeFiles (dir + "/${name}") relName
        else if builtins.match ".*\\.age" name != null
        then [ relName ]
        else []
      )
      (builtins.attrNames (builtins.readDir dir));
in
builtins.listToAttrs (map
  (name: { inherit name; value.publicKeys = [ age-key ]; })
  (findAgeFiles ./. ""))
