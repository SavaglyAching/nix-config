{ config, lib, pkgs, ... }:

{
  # Boot Configuration
  boot = {
    loader = {
      # Disable systemd-boot (enabled in common.nix) to avoid conflict
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
      
      # Use GRUB for this server
      grub.enable = true;
      grub.device = "/dev/xvda"; # or your actual disk device
    };
    kernelParams = [ "console=tty0" ];
    supportedFilesystems = [ "btrfs" ];
  };
}
