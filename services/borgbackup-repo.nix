{ config, lib, pkgs, ... }:

{
  # SOPS template to render the SSH public key for borgbackup
  sops.templates."borgbackup-mac-authorized-keys" = {
    content = config.sops.placeholder."authorized_keys/mac";
    mode = "0444";
  };

  # Borgbackup repository server configuration
  services.borgbackup.repos.mac-test-backup = {
    # Repository storage path
    path = "/var/lib/borgbackup/mac-test-backup";

    # Use a dummy key to satisfy module requirements
    # The actual key is managed via users.users.borg.openssh.authorizedKeys.keyFiles
    authorizedKeys = [ "# Managed by SOPS - see users.users.borg.openssh.authorizedKeys.keyFiles" ];
  };

  services.borgbackup.repos.cloud-backup = {
    # Repository storage path
    path = "/var/lib/borgbackup/cloud-backup";

    # Use a dummy key to satisfy module requirements
    # The actual key is managed via users.users.borg.openssh.authorizedKeys.keyFiles
    authorizedKeys = [ "# Managed by SOPS - see users.users.borg.openssh.authorizedKeys.keyFiles" ];
  };

  # Configure the borg user's SSH authorized_keys using NixOS native method
  # The borgbackup module creates a borg user, and we add our key to it
  users.users.borg.openssh.authorizedKeys.keyFiles = [
    config.sops.templates."borgbackup-mac-authorized-keys".path
  ];
}
