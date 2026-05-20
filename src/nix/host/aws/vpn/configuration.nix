{ config, vars, ... }:
{
  imports = [
    ../../../module/os/linux/aws-minimal.nix
  ];

  # System settings
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Wireguard
  age.secrets."wireguard/vpn/privateKey" = {
    file = ../../../module/secret/wireguard/vpn/privateKey.age;
    mode = "0400";
  };

  networking = {
    nameservers = [ "10.0.0.1" ];

    wireguard.interfaces.wg0 = {
      ips = [ "10.0.2.2/24" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets."wireguard/vpn/privateKey".path;

      peers = [
        {
          # dnshost
          allowedIPs = [ "10.0.2.1/32" "10.0.1.0/24" "10.0.0.1/32" ];
          persistentKeepalive = 30;
          publicKey = "RwFKWUV1e+u7j7qZFYIw0WWNaerCu4od8NQno4yk4k4=";
        }
        {
          # iphone
          allowedIPs = [ "10.0.2.3/32" ];
          persistentKeepalive = 30;
          publicKey = "TxjLSHocViSEkLnnL9ZEuaW9kybPeEha7NhUbtHNfQo=";
        }
        {
          # ipad
          allowedIPs = [ "10.0.2.4/32" ];
          persistentKeepalive = 30;
          publicKey = "gAa/8GP6ExxUxbDZGJjtHTLhgmkD9wHRjikgHT4f8HU=";
        }
      ];
    };
  };
}
