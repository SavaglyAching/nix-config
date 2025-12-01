{ lib, config, pkgs, ... }:

let
  smbServerIP = "cloud";
  smbCredentialsFile = config.sops.templates."smb-credentials".path;

  # Define all the shares you want to mount in this list
  shares = [ "Stuff" "360" "mirrorless" "appdata" ];

in {
  # SOPS template for SMB credentials file
  sops.templates."smb-credentials" = {
    content = ''
      username=${config.sops.placeholder."smb_credentials/username"}
      password=${config.sops.placeholder."smb_credentials/password"}
    '';
    mode = "0400";
  };

  # CIFS utilities for SMB client functionality
  environment.systemPackages = with pkgs; [ cifs-utils ];

  # Dynamic filesystem mount points for SMB shares
  fileSystems = lib.listToAttrs (map (shareName: {
    name = "/mnt/${shareName}";
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