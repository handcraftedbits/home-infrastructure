{ vars, ... }:
{
  age = {
    identityPaths = [ "/etc/age-key" ];
    secrets = {
      "aws/accessKeyId" = {
        file = ./aws/accessKeyId.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "aws/secretAccessKey" = {
        file = ./aws/secretAccessKey.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "linkwarden/apiKey" = {
        file = ./linkwarden/apiKey.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "linkwarden/nextauth/password" = {
        file = ./linkwarden/nextauth/password.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "postgresql/immich/password" = {
        file = ./postgresql/immich/password.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "postgresql/password" = {
        file = ./postgresql/password.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "user/${vars.user.username}/password" = {
        file = ./user/${vars.user.username}/password.age;
        mode = "0400";
        owner = vars.user.username;
      };
      "user/${vars.user.username}/privateKey" = {
        file = ./user/${vars.user.username}/privateKey.age;
        mode = "0600";
        owner = vars.user.username;
      };
    };
  };
}
