{
  config,
  pkgs,
  lib,
  ...
}:

let
  kodiAddonDataDir = ".kodi/userdata/addon_data/pvr.iptvsimple";
  kodiSecretPath = "/run/secrets/kodi-iptv-url";
in
{
  # Install Kodi and the IPTV Simple client addon locally
  home.packages = with pkgs; [
    kodi
    kodiPackages.pvr-iptvsimple
  ];

  # Activation script writes the Kodi IPTV configuration using the decrypted secret
  home.activation.kodiIptvSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        secret_path="${kodiSecretPath}"
        kodi_dir="${config.home.homeDirectory}/${kodiAddonDataDir}"

        mkdir -p "$kodi_dir"

        m3u_url="$(cat "$secret_path" | tr -d '\n')"

        cat > "$kodi_dir/settings.xml" <<EOF
        <settings version="2">
          <setting id="m3uPathType">0</setting>
          <setting id="m3uUrl">$m3u_url</setting>
          <setting id="startNum">1</setting>
          <setting id="catchupPlayEpgTv" default="true">true</setting>
        </settings>
    EOF

        chmod 400 "$kodi_dir/settings.xml"
        cp "$kodi_dir/settings.xml" "$kodi_dir/settings-default.xml"
        chmod 400 "$kodi_dir/settings-default.xml"
  '';
}
