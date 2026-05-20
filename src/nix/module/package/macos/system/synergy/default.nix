{ pkgs, vars, ... }:
{
  imports = if vars.synergy ? allowedClient then [ ./server.nix ] else [ ./client.nix ];

  environment.systemPackages = with pkgs; [
    synergy
  ];
}