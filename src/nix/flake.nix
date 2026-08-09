{
  description = "Home infrastructure";

  inputs = {
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/master";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
  };

  outputs = { agenix, darwin, home-manager, nixpkgs, nixvim, ... }:
    let
      mkHost = import ./module/util/mkHost.nix {
        inherit agenix darwin home-manager nixpkgs nixvim vars;
      };

      users-base = {
        curtiss = {
          fullName = "Curtiss Howard";
          git = {
            name = "Curtiss Howard";
          };
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJv5tcbOeOKwVM0XE6GBY9EvYo23sk5841v6SjLYHIA curtiss@curtisshoward.com";
          username = "curtiss";
        };
      };

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
    in {
      darwinConfigurations = {
        macdesk = mkHost {
          extraVars = {
            synergy.allowedClient = "work";
          };
          hostName = "macdesk";
          hostType = "physical";
          mainUser = "curtiss";
          system = "aarch64-darwin";
        };

        work = mkHost {
          extraVars = {
            synergy.allowedServer = "macdesk.lan.howard.estate";
            user.git.email = "curtiss.howard@analyst1.com";
          };
          hostName = "work";
          hostType = "physical";
          mainUser = "curtiss";
          system = "aarch64-darwin";
        };
      };

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
        datahost = mkHost {
          hostName = "datahost";
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
