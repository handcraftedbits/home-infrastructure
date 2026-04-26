let
  age-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnm6N2Wlqj8nhjUoboYmApjkgBnEBiuSHYzXlx9q/HZ";
in {
  "aws/accessKeyId.age".publicKeys = [ age-key ];
  "aws/secretAccessKey.age".publicKeys = [ age-key ];
  "linkwarden/nextauth/password.age".publicKeys = [ age-key ];
  "postgresql/immich/password.age".publicKeys = [ age-key ];
  "postgresql/password.age".publicKeys = [ age-key ];
  "samba/credentials.age".publicKeys = [ age-key ];
  "user/curtiss/password.age".publicKeys = [ age-key ];
  "user/curtiss/privateKey.age".publicKeys = [ age-key ];
  "wireguard/dnshost/privateKey.age".publicKeys = [ age-key ];
  "wireguard/vpn/privateKey.age".publicKeys = [ age-key ];
}
