{ vars, ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      email = vars.user.git.email;
      name = vars.user.git.name;
    };
  };
}
