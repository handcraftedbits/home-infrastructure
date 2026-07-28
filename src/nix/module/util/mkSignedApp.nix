{ vars }:
let
  homeDirectory = "/Users/${vars.user.username}";

  signingIdentity = "nix-codesign";
in
# Re-signs an application so its TCC grants survive nix updates.
{ name, bundleId ? null, executableName ? null, binary ? null, bundle ? null, deep ? false, onChange ? "" }:
let
  appPath = if inPlace then bundle else "${homeDirectory}/Applications/${name}.app";
  execPath = "${appPath}/Contents/MacOS/${executableName}";
  inPlace = bundle != null;
  slug = builtins.replaceStrings [ " " "." ] [ "-" "-" ] name;
in
{
  inherit appPath execPath;

  module = { lib, ... }: {
    system.activationScripts.postActivation.text = lib.mkIf inPlace (lib.mkBefore ''
      if [ -d "${appPath}" ]; then
        chown -R ${vars.user.username} "${appPath}"
        chmod -R u+w "${appPath}"
      fi
    '');

    home-manager.users.${vars.user.username} = { lib, pkgs, ... }:
      let
        infoPlist = pkgs.writeText "${slug}-Info.plist" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>CFBundleExecutable</key><string>${executableName}</string>
            <key>CFBundleIdentifier</key><string>${bundleId}</string>
            <key>CFBundleName</key><string>${name}</string>
            <key>CFBundlePackageType</key><string>APPL</string>
            <key>LSBackgroundOnly</key><true/>
          </dict>
          </plist>
        '';

        populate = if inPlace then ''
          chmod -R u+w "${appPath}"
        '' else ''
          rm -rf "${appPath}"
          mkdir -p "${appPath}/Contents/MacOS"
          cp "${binary}" "${execPath}"
          cp "${infoPlist}" "${appPath}/Contents/Info.plist"
          chmod -R u+w "${appPath}"
        '';

        identifierFlag = lib.optionalString (!inPlace) ''--identifier "${bundleId}"'';
        deepFlag = lib.optionalString deep "--deep";
      in
      {
        home.activation."sign-${slug}" = lib.hm.dag.entryAfter [ "writeBoundary" "copyApps" ] ''
          if ! /usr/bin/security find-identity -v -p codesigning | grep -q '"${signingIdentity}"'; then
            echo "${name}: no '${signingIdentity}' codesigning identity in the login keychain." >&2
            echo "${name}: see the Code Signing section of README.md to create one." >&2
            exit 1
          fi

          ${populate}

          /usr/bin/codesign --force ${deepFlag} \
            --sign "${signingIdentity}" ${identifierFlag} \
            "${appPath}"

          ${onChange}
        '';
      };
  };
}
