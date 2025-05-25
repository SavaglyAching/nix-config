# modules/services/borg-repository.nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.borgRepository;
in
{
  options.services.borgRepository = {
    enable = mkEnableOption "Enable Borg backup repository server";

    user = mkOption {
      type = types.str;
      default = "borgbackup";
      description = "User to own the Borg repository and handle SSH connections for backups.";
    };

    group = mkOption {
      type = types.str;
      default = "borgbackup";
      description = "Group for the Borg repository user.";
    };

    repositoryPath = mkOption {
      type = types.path;
      # Example: /srv/borg-repos/unraid-backup
      default = "/persist/borgbackup";
      description = "Path to the Borg backup repository. This exact path will be used by borg init/create.";
    };

    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHetc user@unraid-client" ];
      description = ''
        List of public SSH keys from client machines (e.g., Unraid) authorized to push backups.
        These keys will be restricted to only run 'borg serve' for the specified repositoryPath.
      '';
    };

    # Consider adding listenAddress and port if not using default SSH daemon settings
    # For now, assumes standard SSH on port 22.
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      # The home directory is where .ssh/authorized_keys will be placed.
      # Borg itself doesn't strictly need its home to be the repo path,
      # but this setup is common for service users managing their own keys.
      home = "/var/lib/${cfg.user}"; # A dedicated home, not necessarily the repo itself.
      createHome = true;
      homeMode = "0700"; # Restrict access to home
      description = "Borg Backup Repository User";
    };

    users.groups.${cfg.group} = {};

    # Ensure the repository path itself exists and has correct permissions
    # The borgbackup user needs to be able to write here.
    systemd.tmpfiles.rules = [
      # Create home for .ssh/authorized_keys
      "d /var/lib/${cfg.user} 0700 ${cfg.user} ${cfg.group} - -"
      "d /var/lib/${cfg.user}/.ssh 0700 ${cfg.user} ${cfg.group} - -"
      # Create the actual repository path
      "d ${cfg.repositoryPath} 0700 ${cfg.user} ${cfg.group} - -"
    ];

    # Configure SSH authorized keys for the borg user
    users.users.${cfg.user}.openssh.authorizedKeys.keys = map (keyStr:
      let
        # Construct the command string for borg serve
        # This ensures the client can only run borg serve and only for the specified repository.
        borgServeCommand = "${pkgs.borgbackup}/bin/borg serve --restrict-to-path ${cfg.repositoryPath}";
      in
      "command=\"${borgServeCommand}\",restrict ${keyStr}"
    ) cfg.authorizedKeys;

    # Ensure borgbackup package is available on the system
    environment.systemPackages = [ pkgs.borgbackup ];

    # Reminder: Ensure your main SSH service (services.openssh.enable) is true
    # and firewall (e.g. networking.firewall.allowedTCPPorts) allows SSH connections.
  };
}