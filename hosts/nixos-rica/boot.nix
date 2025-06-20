{ config, lib, pkgs, ... }:

{
  # Boot Configuration
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = false;
        device = "/dev/xvda"; 
      };
    };
    kernelParams = [ "console=ttyS0,115200n8" ];
    supportedFilesystems = [ "btrfs" ];
  };
}


mount -o subvol=@root /dev/xvda2 /mnt
mount -o subvol=@nix /dev/xvda2 /mnt/nix
mount -o subvol=@home /dev/xvda2 /mnt/home
mount -o subvol=@persist /dev/xvda2 /mnt/persist
mount -o subvol=@snapshots /dev/xvda2 /mnt/snapshots