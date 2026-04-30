{ vars }:
{ containers ? [] }:
{ pkgs, lib, config, ... }:
let
  inherit (builtins) listToAttrs readDir filter attrNames stringLength substring concatLists;

  allFiles = concatLists (map (c: nixFilesIn c.directory) enabledContainers);
  configEntries = concatLists (map mkConfigEntry enabledContainers);
  containerFiles = filter (f: !(isEnvironmentFile f)) allFiles;
  dataEntries = concatLists (map mkDataEntry enabledContainers);
  enabledContainers = filter (c: c.enabled or true) containers;
  environmentFiles = filter isEnvironmentFile allFiles;

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
    value = {
      onChange = reloadCommand;
      text = import file { inherit pkgs vars; };
    };
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
        mkdir -p ${config.xdg.configHome}/containers/environment
        echo "${import file { inherit pkgs vars; }}" > ${path}
        chmod 600 ${path}
      '';
    };

  nixFilesIn = dir:
    map (name: dir + "/${name}")
      (filter (name: hasSuffix ".nix" name)
        (attrNames (readDir dir)));

  reloadCommand = ''
    ${pkgs.systemd}/bin/systemctl --user daemon-reload || true
  '';

  stripSuffix = suffix: s:
    if hasSuffix suffix s then
      substring 0 (stringLength s - stringLength suffix) s
    else
      s;
in
{
  home.activation = listToAttrs (map mkEnvActivation environmentFiles);
  xdg.configFile = listToAttrs (map mkContainerEntry containerFiles ++ configEntries);
  xdg.dataFile = listToAttrs dataEntries;
}
