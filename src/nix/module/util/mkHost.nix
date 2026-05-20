{ agenix, darwin, home-manager, nixpkgs, nixvim, vars }:
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
{ hostName, hostType, mainUser, system ? "x86_64-linux", extraVars ? {} }:
let
  agenixModule = if isMacos then agenix.darwinModules.default else agenix.nixosModules.default;
  hardwareModule = if isMacos then [] else [ /etc/nixos/hardware-configuration.nix ];
  hmModule = if isMacos then home-manager.darwinModules.home-manager else home-manager.nixosModules.default;

  isMacos = builtins.match ".*-darwin" system != null;

  fixedVariables = {
    inherit hostName;

    user = vars.users.${mainUser} // {
      password = "${secretsDir}/user/${mainUserUsername}/password";
    };
  };

  mainUserUsername = vars.users.${mainUser}.username;

  mkSystem = if isMacos then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;

  resolvedVariables = nixpkgs.lib.recursiveUpdate
    (nixpkgs.lib.recursiveUpdate
      (vars // fixedVariables)
      secretVars)
    extraVars;
in
mkSystem {
  inherit system;

  modules = hardwareModule ++ [
    agenixModule
    hmModule

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
        users.${resolvedVariables.user.username} = {
          home.homeDirectory = if isMacos
            then "/Users/${resolvedVariables.user.username}"
            else "/home/${resolvedVariables.user.username}";
          home.stateVersion = resolvedVariables.nixosVersion;
        };
      };
    }
  ];

  specialArgs = {
    inherit system;

    vars = resolvedVariables;
  };
}
