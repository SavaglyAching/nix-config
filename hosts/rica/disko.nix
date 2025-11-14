# hosts/rica/disko.nix
# Declarative disk configuration for Rica (Xen VM)
# This configuration sets up:
# - GRUB bootloader on /dev/xvda
# - ext4 boot partition
# - BTRFS root with subvolumes for system, home, nix, snapshots, and persistent data
# - Matches existing manual BTRFS layout on production rica system

{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/xvda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "8300";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  # Root filesystem subvolume
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Home subvolume
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Nix store subvolume
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Snapshots subvolume
                  "@snapshots" = {
                    mountpoint = "/snapshots";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Persistent data subvolume (for containers, databases, etc.)
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # Grub bootloader configuration
  boot.loader.grub = {
    enable = true;
    device = "/dev/xvda";
    useOSProber = false;
  };

  # No swap on rica
  swapDevices = [ ];
}
