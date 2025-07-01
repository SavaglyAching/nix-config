{ config, lib, pkgs, ... }:

{
  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "console=ttyS0,115200n8" ];
    supportedFilesystems = [ "btrfs" ];
  };
}