{ pkgs, vars, ... }:
{
  home-manager.users.${vars.user.username} = { ... }: {
    imports = [
      ./kitty-hm.nix
    ];
  };

  # Signed with a stable identity so that permission grants survive rebuilds; see README.md.
  system.appIdentity.apps = with pkgs; [
    kitty
  ];

  # Secure Keyboard Entry (opt+cmd+s) blocks other applications from seeing keystrokes while kitty is focused, which
  # makes AeroSpace nag about secure input.
  system.defaults.CustomUserPreferences."net.kovidgoyal.kitty".SecureKeyboardEntry = false;
}
