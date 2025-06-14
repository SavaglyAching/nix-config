{ config, pkgs, ... }:

let
  # Define the path to the Borg repository
  borgRepoPath = "/persist/borg-server";

  # Define the user for Borg backups
  borgUserName = "borgbackup";
  # It's highly recommended to use key-based authentication.
  # Replace this with the actual public SSH key of your Unraid machine (or the key you'll use for backups).
  # You'll generate this key on your Unraid machine in Part 2.
  unraidClientSshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8EHcXtD/72xbcOWWtdCAGvbC9glO//n9QENWZ4RKtb root@33Clouds"; # <--- REPLACE THIS WITH UNRAID'S PUBLIC KEY

in
{
  # 1. Create a dedicated user for borg backups
  users.users.${borgUserName} = {
    isSystemUser = true;
    group = borgUserName;
    home = borgRepoPath; # Or another suitable home, repo path is critical for authorized_keys
    createHome = true; # Creates the directory if it doesn't exist
    shell = pkgs.bash; # Or pkgs.stdenv.shell (usually /bin/sh)
  };

  users.groups.${borgUserName} = {};

  # 2. Configure SSH to allow restricted Borg access for this user
  services.openssh = {
    enable = true;
    # It's good practice to use a non-standard port if your server is internet-facing
    # port = 2222; # Example, remember to open this port in your firewall

    # Configure authorized keys for the borg user
    # This is the core of the server-side Borg setup.
    # It restricts the 'borgbackup' user to only be able to run 'borg serve'
    # and only for the specified repository path.
    authorizedKeysFiles = [
      # You can also manage authorized_keys directly if you prefer,
      # but this integrates it into your NixOS configuration.
      (pkgs.writeText "borgbackup_authorized_keys" ''
        command="borg serve --restrict-to-repository ${borgRepoPath}",restrict ${unraidClientSshKey}
      '').outPath
    ];

    # Optional: Further harden SSH if desired
    # PasswordAuthentication = false;
    # PermitRootLogin = "no";
  };

  # 3. Ensure the Borg package is available (for `borg serve`)
  #    Although `borg serve` is called via SSH, having borgbackup installed on the server
  #    ensures the command is available.
  environment.systemPackages = [ pkgs.borgbackup ];

  # 4. Create and set permissions for the Borg repository directory
  #    This step ensures the directory exists and the borgbackup user can write to it.
  systemd.tmpfiles.rules = [
    "d ${borgRepoPath} 0700 ${borgUserName} ${borgUserName} - -"
  ];

  # 5. Firewall Configuration (if you have a firewall enabled)
  # networking.firewall.allowedTCPPorts = [ 22 ]; # Or your custom SSH port
}