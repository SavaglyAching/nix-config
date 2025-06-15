{ lib, ... }: # This assumes you're in a file that has `lib` available, like a NixOS module.

let
  # List of your share names
  shares = [ "360" "appdatassd" "code" "minecraft" "mirrorless" ];

  # A function that creates a single fileSystem entry for a given share name
  mkShareMount = shareName: {
    # The name of the attribute will be the mount point, e.g., "/mnt/360"
    name = "/mnt/${shareName}";
    # The value of the attribute is the configuration for that mount
    value = {
      device = "//cloud/${shareName}";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in [
        "${automount_opts},credentials=/home/ham/smb-secrets,uid=1000,gid=100,noserverino"
      ];
    };
  };

in
{
  # Use lib.listToAttrs to convert our list of shares into the desired attribute set
  fileSystems = lib.listToAttrs (map mkShareMount shares);
}