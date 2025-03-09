{ config, lib, pkgs, ... }:

{
  # Boot Configuration
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/xvda";
        extraConfig = ''
          serial --unit=0 --speed=115200
          terminal_input serial console
          terminal_output serial console
        '';
      };
    };
    supportedFilesystems = [ "btrfs" ];
    kernelParams = [ "console=ttyS0,115200n8" ];
  };
}