{ agenix, home-manager, nixpkgs, nixvim, vars }:
let
  secretsDir = "/run/agenix";

  secretNames = map
    (nixpkgs.lib.removeSuffix ".age")
    (builtins.attrNames (import ../secret/secrets.nix));

  secretVars = builtins.foldl' (acc: name:
    nixpkgs.lib.recursiveUpdate acc
      (nixpkgs.lib.setAttrByPath (nixpkgs.lib.splitString "/" name) "${secretsDir}/${name}")
  ) {} secretNames;
in
{ hostName, hostType, mainUser, system ? "x86_64-linux" }:
let
  fixedVariables = {
    inherit hostName;

    user = vars.users.${mainUser} // {
      password = "${secretsDir}/user/${mainUser}/password";
    };
  };
  resolvedVariables = nixpkgs.lib.recursiveUpdate
    (vars // fixedVariables)
    secretVars;
in
nixpkgs.lib.nixosSystem {
  modules = [
    agenix.nixosModules.default
    home-manager.nixosModules.default

    /etc/nixos/hardware-configuration.nix
    ../../host/${hostType}/${hostName}/configuration.nix
    {
      home-manager = {
        sharedModules = [
          nixvim.homeModules.nixvim
        ];
        extraSpecialArgs = {
          vars = resolvedVariables;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${resolvedVariables.user.username}.home.stateVersion = resolvedVariables.nixosVersion;
      };
    }
  ];

  specialArgs = {
    vars = resolvedVariables;
  };

  inherit system;
}
