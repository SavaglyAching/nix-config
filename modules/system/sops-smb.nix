{ lib, config, pkgs, unstable, ... }:

let
  smbServerIP = "192.168.2.88";
  smbCredentialsFile = "/run/secrets/smb-credentials-file";

  # Define all the shares you want to mount in this list
  shares = [ "Stuff" "360" "mirrorless" "appdata" ];

in
{
  # 1. Configure sops-nix (No changes needed, this is perfect)
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets."smb-username" = {
      key = "smb_credentials/username";
    };
    secrets."smb-password" = {
      key = "smb_credentials/password";
    };
  };

  # 2. Activation Script (No changes needed, one file works for all)
  system.activationScripts.zz-createSmbCredentials = {
    text = ''
      (
        echo -n "username="
        cat ${config.sops.secrets."smb-username".path}
        echo ""
        echo -n "password="
        cat ${config.sops.secrets."smb-password".path}
        echo ""
      ) > ${smbCredentialsFile}
      chmod 400 ${smbCredentialsFile}
    '';
  };

  # 3. Packages (No changes needed)
  environment.systemPackages = with pkgs; [
    cifs-utils
    (unstable.sops)
  ];

  # 4. Mount Points (Refactored for multiple shares)
  # This dynamically generates a mount point for each item in the `shares` list.
  fileSystems = lib.listToAttrs (map (shareName: {
    # 'name' becomes the attribute key, e.g., fileSystems."/mnt/360"
    name = "/mnt/${shareName}";
    # 'value' is the configuration for that mount point
    value = {
      device = "//${smbServerIP}/${shareName}";
      fsType = "cifs";
      options = [
        "credentials=${smbCredentialsFile}"
        "uid=1000"
        "gid=100"
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
      ];
    };
  }) shares);
}