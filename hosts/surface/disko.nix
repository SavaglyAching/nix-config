# hosts/surface/disko.nix
# Declarative disk configuration for Surface using Disko
# This configuration sets up:
# - EFI boot partition
# - BTRFS root with subvolumes for system, home, nix, snapshots
# - Swapfile support with automatic creation

{ pkgs, ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Device is specified at installation time via disko script
        device = "/dev/disk/by-id/some-disk-id";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force overwrite
                subvolumes = {
                  # Root subvolume
                  "@" = {
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
                  # Snapshots subvolume (not mounted by default)
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Swap subvolume
                  "@swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # Swapfile configuration
  swapDevices = [{
    device = "/swap/swapfile";
  }];

  # Automatically create swapfile if it doesn't exist
  system.activationScripts.setupSwap = {
    text = ''
      if [ ! -f /swap/swapfile ]; then
        mkdir -p /swap
        ${pkgs.btrfs-progs}/bin/btrfs filesystem mkswapfile --size 8g /swap/swapfile
      fi
    '';
  };
}
