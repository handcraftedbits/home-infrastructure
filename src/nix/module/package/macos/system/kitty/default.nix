{ pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
  ];

  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./kitty-hm.nix
    ];
  };
}
