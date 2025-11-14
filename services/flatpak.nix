{ config, pkgs, lib, ... }:

{
  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable XDG Desktop Portal for Flatpak integration
  xdg.portal.enable = true;

  # Configure portals based on desktop environment
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  # System packages for Flatpak management
  environment.systemPackages = with pkgs; [
    flatpak
  ];
}
