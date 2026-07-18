{ ... }:
{
  homebrew = {
    enable = true;
    greedyCasks = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--force" ];
      upgrade = true;
    };
  };
}
