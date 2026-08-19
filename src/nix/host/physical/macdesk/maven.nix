{ config, lib, osConfig, ... }:
let
  gpgKeyName = "BB68FC883683ECAB";
  password = osConfig.age.secrets."sonatype/password".path;
  settings = "${config.home.homeDirectory}/.m2/settings.xml";
  username = osConfig.age.secrets."sonatype/username".path;
in
{
  home.activation.mavenSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -r "${password}" ] && [ -r "${username}" ]; then
      umask 077

      install -d -m 700 "${dirOf settings}"

      cat > "${settings}" <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0">
      <servers>
        <server>
          <id>central</id>
          <username>$(cat "${username}")</username>
          <password>$(cat "${password}")</password>
        </server>
      </servers>

      <profiles>
        <profile>
          <id>central</id>
          <properties>
            <gpg.keyname>${gpgKeyName}</gpg.keyname>
          </properties>
        </profile>
      </profiles>

      <activeProfiles>
        <activeProfile>central</activeProfile>
      </activeProfiles>
    </settings>
    EOF

      chmod 600 "${settings}"
    else
      echo "maven: sonatype credentials are not readable; skipping settings.xml"
    fi
  '';
}
