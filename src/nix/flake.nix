{
  description = "Home infrastructure";

  inputs = {
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim/nixos-25.11";
    };
  };

  outputs = { agenix, home-manager, nixpkgs, nixvim, ... }:
    let
      vars = {
        acme.email = "curtiss@curtisshoward.com";
        aws.region = "us-east-1";
        cifs.server = "nas.lan.howard.estate";
        nfs.server = "nas.lan.howard.estate";
        nixosVersion = "25.11";
        timeZone = "America/New_York";
        users = {
          curtiss = {
            fullName = "Curtiss Howard";
            git = {
              email = "opensource@handcraftedbits.com";
              name = "Curtiss Howard";
            };
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJv5tcbOeOKwVM0XE6GBY9EvYo23sk5841v6SjLYHIA curtiss@curtisshoward.com";
            username = "curtiss";
          };
        };
      };

      mkHost = import ./module/util/mkHost.nix {
        inherit agenix home-manager nixpkgs nixvim vars;
      };
    in {
      nixosConfigurations = {
        aihost = mkHost {
          hostName = "aihost";
          hostType = "vm";
          mainUser = "curtiss";
        };
        apphost = mkHost {
          hostName = "apphost";
          hostType = "vm";
          mainUser = "curtiss";
        };
        dbhost = mkHost {
          hostName = "dbhost";
          hostType = "vm";
          mainUser = "curtiss";
        };
        dnshost = mkHost {
          hostName = "dnshost";
          hostType = "physical";
          mainUser = "curtiss";
        };
        vpn = mkHost {
          hostName = "vpn";
          hostType = "aws";
          mainUser = "curtiss";
          system = "aarch64-linux";
        };
      };
    };
}
