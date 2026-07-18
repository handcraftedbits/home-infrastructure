{ vars, ... }:
{
  programs.zsh.initContent = ''
    wg-start-stop() {
      if sudo wg show wg0 > /dev/null 2>&1; then
        sudo wg-quick down wg0
      else
        sudo install -d -m 700 /etc/wireguard
        sudo sh -c 'umask 077; {
          printf "%s\n" "[Interface]"
          printf "%s\n" "Address = 10.0.2.5/24"
          printf "%s\n" "DNS = 10.0.0.1"
          printf "PrivateKey = %s\n" "$(cat ${vars.wireguard.work.privateKey})"
          printf "\n%s\n" "[Peer]"
          printf "%s\n" "PublicKey = 51iL6RTNhcigUIWdwX7tSifWvkNbrLwzzyDafcahREw="
          printf "%s\n" "Endpoint = vpn.curtisshoward.com:51820"
          printf "%s\n" "AllowedIPs = 10.0.0.0/8"
          printf "%s\n" "PersistentKeepalive = 30"
        } > /etc/wireguard/wg0.conf'
        sudo wg-quick up wg0
      fi
    }
  '';

  programs.zsh.shellAliases = {
    a1-format = "mvn -Pformat impsort:sort formatter:format";
    a1-startui = "npx -p @angular/cli ng serve --ssl true --host 0.0.0.0";
  };
}
