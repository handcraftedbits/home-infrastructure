{ vars, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = false;
      user = {
        email = vars.user.git.email;
        name = vars.user.git.name;
      };
    };
  };
}
