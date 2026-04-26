{ lib, osConfig, vars, ... }:
{
  # Public and private keys.
  home.file.".ssh/id_ed25519.pub".text = vars.user.publicKey;
  home.activation.sshPrivateKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    install -d -m 700 "$HOME/.ssh"
    ln -sf "${osConfig.age.secrets."user/${vars.user.username}/privateKey".path}" "$HOME/.ssh/id_ed25519"
  '';

  programs.ssh.matchBlocks."*".addKeysToAgent = "yes";
  programs.zsh.oh-my-zsh.plugins = [ "ssh-agent" ];
}
