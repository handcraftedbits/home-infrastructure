{ config, lib, osConfig, pkgs, ... }:
let
  gnupgHome = config.programs.gpg.homedir;
  privateKey = osConfig.age.secrets."gpg/privateKey".path;
in
{
  home.activation.gpgPrivateKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -r "${privateKey}" ]; then
      install -d -m 700 "${gnupgHome}"

      ${pkgs.gnupg}/bin/gpg --batch --quiet --homedir "${gnupgHome}" --import "${privateKey}"

      fingerprint="$(${pkgs.gnupg}/bin/gpg --batch --with-colons --homedir "${gnupgHome}" \
        --import-options show-only --import "${privateKey}" \
        | ${pkgs.gawk}/bin/awk -F: '$1 == "fpr" { print $10; exit }')"

      echo "$fingerprint:6:" \
        | ${pkgs.gnupg}/bin/gpg --batch --quiet --homedir "${gnupgHome}" --import-ownertrust
    else
      echo "gnupg: ${privateKey} is not readable; skipping private key import"
    fi
  '';

  programs.gpg = {
    dirmngrSettings.disable-ipv6 = true;

    enable = true;

    settings.keyserver = "hkps://keyserver.ubuntu.com";
  };
}
