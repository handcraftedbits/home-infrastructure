{ pkgs, vars, ... }:
''
  encode() {
    printf '%s' "$1" | ${pkgs.python3}/bin/python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read(), safe='''), end=''')"
  }
  credentials="/run/agenix/samba/credentials"
  username=$(encode "$(grep '^username=' "$credentials" | cut -d= -f2)")
  password=$(encode "$(grep '^password=' "$credentials" | cut -d= -f2)")

  mount | grep -q "${vars.cifs.server}/family"   || osascript -e "mount volume \"smb://$username:$password@${vars.cifs.server}/family\""
  mount | grep -q "${vars.cifs.server}/media"    || osascript -e "mount volume \"smb://$username:$password@${vars.cifs.server}/media\""
  mount | grep -q "${vars.cifs.server}/software" || osascript -e "mount volume \"smb://$username:$password@${vars.cifs.server}/software\""
''
