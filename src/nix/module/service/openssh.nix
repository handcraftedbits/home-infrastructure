{ lib, vars, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false; 
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "no";
      PubkeyAuthentication = true;
    };
  };

  users.users.${vars.user.username}.openssh.authorizedKeys.keys = [ vars.user.publicKey ];
}
