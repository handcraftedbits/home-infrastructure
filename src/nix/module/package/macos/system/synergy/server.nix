{ vars, ... }:
{
  environment.etc."synergy/synergy.conf".text = import ./synergy.conf.nix { inherit vars; };

  home-manager.users.${vars.user.username} = { ... }: {
    home.file."Library/LaunchAgents/com.synergy.plist".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>AssociatedBundleIdentifiers</key>
        <array>
          <string>synergy</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>com.synergy</string>
        <key>ProgramArguments</key>
        <array>
          <string>/Applications/Nix Apps/Synergy.app/Contents/MacOS/synergys</string>
          <string>-c</string>
          <string>/etc/synergy/synergy.conf</string>
          <string>-f</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    '';
  };
}