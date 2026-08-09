{ vars }:
{ containers ? [] }:
{ pkgs, lib, config, ... }:
let
  inherit (builtins) listToAttrs readDir filter attrNames stringLength substring concatLists;

  allFiles = concatLists (map (c: nixFilesIn c.directory) enabledContainers);

  configEntries = concatLists (map mkConfigEntry enabledContainers);

  containerFiles = filter (f: !(isEnvironmentFile f)) allFiles;

  dataEntries = concatLists (map mkDataEntry enabledContainers);
  desiredUnitsFile = pkgs.writeText "quadlet-desired-units"
    (lib.concatMapStrings (r: "${r.name} ${r.hash}\n") unitRecords);

  enabledContainers = filter (c: c.enabled or true) containers;

  environmentFiles = filter isEnvironmentFile allFiles;

  envActivationNames = map
    (file: "writeEnv_${builtins.replaceStrings [ "/" "." ] [ "_" "_" ] (stripSuffix ".environment.nix" (baseNameOf file))}")
    environmentFiles;

  hasSuffix = suffix: s:
    let
      suffixLen = stringLength suffix;
      sLen = stringLength s;
    in
      sLen >= suffixLen &&
      substring (sLen - suffixLen) suffixLen s == suffix;

  isEnvironmentFile = file:
    hasSuffix ".environment.nix" (baseNameOf file);

  mkConfigEntry = c:
    let
      configDir = c.directory + "/config";
    in
      if builtins.pathExists configDir then
        [{
          name = "${baseNameOf c.directory}";
          value.source = configDir;
        }]
      else
        [];

  mkContainerEntry = file: {
    name = "containers/systemd/${stripSuffix ".nix" (baseNameOf file)}";
    value.text = import file { inherit pkgs vars; };
  };

  mkDataEntry = c:
    let
      dataDir = c.directory + "/data";
    in
      if builtins.pathExists dataDir then
        [{
          name = "${baseNameOf c.directory}";
          value.source = dataDir;
        }]
      else
        [];

  mkEnvActivation = file:
    let
      name = stripSuffix ".environment.nix" (baseNameOf file);
      path = "${config.xdg.configHome}/containers/environment/${name}";
    in
    {
      name = "writeEnv_${builtins.replaceStrings [ "/" "." ] [ "_" "_" ] name}";
      value = lib.hm.dag.entryAfter [ "writeBoundary" "agenix" ] ''
        # secrets: ${secretsHash}
        mkdir -p ${config.xdg.configHome}/containers/environment
        echo "${import file { inherit pkgs vars; }}" > ${path}
        chmod 600 ${path}
      '';
    };

  # Podman quadlet extension -> generated systemd unit suffix.
  mkUnitName = file:
    let
      quadletFile = stripSuffix ".nix" (baseNameOf file);
      parts = builtins.match "(.*)\\.([a-z]+)" quadletFile;
      base = builtins.elemAt parts 0;
      ext = builtins.elemAt parts 1;
    in
      if ext == "container" || ext == "kube" then "${base}.service"
      else if ext == "network" then "${base}-network.service"
      else if ext == "pod" then "${base}-pod.service"
      else if ext == "volume" then "${base}-volume.service"
      else null;

  mkUnitRecord = file:
    let
      unitName = mkUnitName file;
    in
      if unitName == null then [] else [{
        hash = builtins.hashString "sha256" (import file { inherit pkgs vars; });
        name = unitName;
      }];

  nixFilesIn = dir:
    map (name: dir + "/${name}")
      (filter (name: hasSuffix ".nix" name)
        (attrNames (readDir dir)));

  secretsHash = import ./secretsHash.nix { inherit lib; };

  stripSuffix = suffix: s:
    if hasSuffix suffix s then
      substring 0 (stringLength s - stringLength suffix) s
    else
      s;

  unitRecords = concatLists (map mkUnitRecord containerFiles);
in
{
  home.activation = listToAttrs (map mkEnvActivation environmentFiles) // {
    # Stops units whose quadlet source disappeared (renamed/removed containers), restarts ones whose content changed,
    # and starts newly-added ones.
    reloadQuadlets = lib.hm.dag.entryAfter ([ "writeBoundary" "agenix" ] ++ envActivationNames) ''
      stateDir="${config.xdg.stateHome}/quadlets"
      stateFile="$stateDir/units"
      mkdir -p "$stateDir"
      touch "$stateFile"

      ${pkgs.systemd}/bin/systemctl --user daemon-reload

      addedFile=$(mktemp)
      changedFile=$(mktemp)
      removedFile=$(mktemp)

      ${pkgs.gawk}/bin/awk -v addedFile="$addedFile" -v changedFile="$changedFile" -v removedFile="$removedFile" '
        FNR == NR { old[$1] = $2; next }
        {
          new[$1] = $2
          if (!($1 in old)) {
            print $1 > addedFile
          } else if (old[$1] != $2) {
            print $1 > changedFile
          }
        }
        END {
          for (name in old) {
            if (!(name in new)) print name > removedFile
          }
        }
      ' "$stateFile" "${desiredUnitsFile}"

      while read -r name; do
        [ -n "$name" ] || continue
        ${pkgs.systemd}/bin/systemctl --user stop "$name" \
          || echo "reloadQuadlets: failed to stop $name" >&2
      done < "$removedFile"

      while read -r name; do
        [ -n "$name" ] || continue
        ${pkgs.systemd}/bin/systemctl --user restart "$name" \
          || echo "reloadQuadlets: failed to restart $name" >&2
      done < "$changedFile"

      while read -r name; do
        [ -n "$name" ] || continue
        ${pkgs.systemd}/bin/systemctl --user start "$name" \
          || echo "reloadQuadlets: failed to start $name" >&2
      done < "$addedFile"

      rm -f "$addedFile" "$changedFile" "$removedFile"
      cp "${desiredUnitsFile}" "$stateFile"
    '';
  };
  xdg.configFile = listToAttrs (map mkContainerEntry containerFiles ++ configEntries);
  xdg.dataFile = listToAttrs dataEntries;
}
