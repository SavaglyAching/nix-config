{ config, lib, pkgs, ... }:

{
  # Use systemd-boot for modern UEFI systems.
  # It's simpler and faster than GRUB for UEFI-only setups.
  boot.loader.systemd-boot.enable = true;

  # Allow the bootloader to modify EFI variables.
  # This is required for systemd-boot to manage boot entries.
  # Use lib.mkDefault to allow hosts to override (e.g., Asahi requires false)
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
}
