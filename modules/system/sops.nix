{ config, pkgs, ... }:

{
  imports = [
    # Assuming secrets.yaml is in the same directory as this configuration.nix
    # You might need to adjust the path if your secrets are elsewhere.
    ../../secrets.yaml
  ];

  # 1. Configure sops-nix
  sops = {
    enable = true;
    # This is the modern and recommended way.
    # sops-nix will automatically use the host's private SSH key to decrypt secrets
    # during system activation. This avoids manually managing private keys.
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # 2. Define the templated credentials file
    # This creates a file at `/run/secrets/smb-credentials` populated with decrypted secrets.
    templates."smb-credentials" = {
      # This file will be owned by root with 0400 permissions, perfect for mount.cifs.
      path = "/run/secrets/smb-credentials";
      # The content is a template. sops-nix will replace the placeholders
      # with the decrypted values from your secrets.yaml file.
      content = ''
        username=${config.sops.secrets.smb_username}
        password=${config.sops.secrets.smb_password}
      '';
    };

    # This section makes the individual secrets available under config.sops.secrets.*
    # The template above uses this to access the values.
    secrets = {
      smb_username = {};
      smb_password = {};
    };
  };

  # 3. Install necessary packages for SMB/CIFS mounts
  environment.systemPackages = [
    pkgs.cifs-utils
  ];

  # 4. Declaratively mount the SMB share using the sops-nix generated file
  fileSystems."/mnt/Stuff" = {
    device = "//192.168.2.88/Stuff"; # <-- IMPORTANT: Change to your server IP and share name
    fsType = "cifs";
    options = let
      # The `credentials` option points directly to the Nix-managed path of our secret file.
      credentialsFile = config.sops.templates."smb-credentials".path;
    in [
      "credentials=${credentialsFile}"
      "uid=1000"  # Optional: Set the owner of the mounted files. Change to your user's UID.
      "gid=100"   # Optional: Set the group of the mounted files. Change to your user's GID (e.g., 'users').
      "rw"        # Mount as read-write
      "_netdev"   # Signifies a network device, delays mounting until network is up.
      "noauto"    # Optional: Don't mount at boot, but allow `mount /mnt/media`
      "x-systemd.automount" # Recommended: Mount on first access.
      # "vers=3.0"  # Optional: Specify SMB protocol version if needed
    ];
  };

}