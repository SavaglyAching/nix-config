# /etc/nixos/configuration.nix

{ config, lib, pkgs, ... }:

{
  # --- CORRECTED CONFIGURATION FOR A LEGACY BIOS VPS ---

  boot.loader.grub = {
    enable = true;
    # IMPORTANT: Verify this device name. Use the `lsblk` command in the
    # rescue shell to find your main disk. It is usually /dev/vda or /dev/sda.
    device = "/dev/vda";

    # Make the boot menu visible on VPS consoles
    timeout = 10;
    terminal = [ "console" "serial" ];
  };

  # Also add the kernel parameter to fix the hang after "Booting the kernel"
  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  # --- REMOVE OR COMMENT OUT THE ENTIRE boot.loader.efi SECTION ---
  # boot.loader.efi.canTouchEfiVariables = false;

}