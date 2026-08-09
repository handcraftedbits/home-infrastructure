{ config, lib, pkgs, vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  imports = [
    ../../../module/os/linux/internal/physical.nix
    ./service

    util.mkDefaultMounts
    (util.mkNfsMount {
      localPath = "/mnt/container";
      remotePath = "/mnt/vault02/container_dnshost_lan_howard_estate";
    })
  ];

  # System settings
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.ip_unprivileged_port_start" = lib.mkForce 53;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Packages
  environment.systemPackages = [ pkgs.unison ];

  # Quadlets
  home-manager.users.${vars.user.username}.imports = [
    (util.mkUserQuadlets {
      containers = [
        { directory = ./container/adguardhome; }
        { directory = ./container/traefik; }
      ];
    })
  ];

  # Wireguard
  age.secrets."wireguard/dnshost/privateKey" = {
    file = ../../../module/secret/wireguard/dnshost/privateKey.age;
    mode = "0400";
  };

  networking = {
    nameservers = [ "10.0.0.1" ];

    wireguard.interfaces.wg0 = {
      ips = [ "10.0.2.1/24" ];
      privateKeyFile = config.age.secrets."wireguard/dnshost/privateKey".path;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o enp2s0f0 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.2.0/24 -o enp2s0f0 -j MASQUERADE
      '';

      peers = [
        # vpn.curtisshoward.com
        {
          publicKey = "51iL6RTNhcigUIWdwX7tSifWvkNbrLwzzyDafcahREw=";
          allowedIPs = [ "10.0.2.0/24" ];
          endpoint = "vpn.curtisshoward.com:51820";
          persistentKeepalive = 30;
        }
      ];
    };
  };
}
