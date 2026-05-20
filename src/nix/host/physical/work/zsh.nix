{ ... }:
{
  programs.zsh.shellAliases = {
    a1-format = "mvn -Pformat impsort:sort formatter:format";
    a1-startui = "npx -p @angular/cli ng serve --ssl true --host 0.0.0.0";
  };
}
