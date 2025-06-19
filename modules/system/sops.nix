{ config, pkgs, unstable, ... }:

let
  smbCredentialsFile = "/run/secrets/smb-credentials-file";
in
{
  # 1. Configure sops-nix (Final, Cleaned Version)
  sops = {
    # Set the default location for the encrypted file.
    defaultSopsFile = ../../secrets.yaml;

    # Let sops-nix manage the output paths automatically.
    # The paths will still be available at config.sops.secrets.<name>.path
    secrets."smb-username" = {
      key = "smb_credentials/username";
    };
    secrets."smb-password" = {
      key = "smb_credentials/password";
    };
  };

  # 2. Activation Script (No changes needed, this is correct)
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

  # 4. Mount Point (No changes needed)
  fileSystems."/mnt/Stuff" = {
    device = "//192.168.2.88/Stuff";
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
}