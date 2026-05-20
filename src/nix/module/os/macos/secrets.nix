{ pkgs, vars, ... }:
{
  age = {
    identityPaths = [ "/etc/age-key" ];
    secrets = {
      "aws/accessKeyId" = {
        file = ../../../module/secret/aws/accessKeyId.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "aws/secretAccessKey" = {
        file = ../../../module/secret/aws/secretAccessKey.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "samba/credentials" = {
        file = ../../../module/secret/samba/credentials.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "user/${vars.user.username}/privateKey" = {
        file = ../../../module/secret/user/${vars.user.username}/privateKey.age;
        mode = "0600";
        owner = vars.user.username;
      };
    };
  };
}
