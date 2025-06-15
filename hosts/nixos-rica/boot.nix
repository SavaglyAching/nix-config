{ config, lib, pkgs, ... }:

{
  # Boot Configuration
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = false;
        device = "/dev/xvda"; # or /dev/sda
      };
    };
    kernelParams = [ "console=ttyS0,115200n8" ];
    supportedFilesystems = [ "btrfs" ];
  };
}