{ config, lib, pkgs, ... }:

{
  # KDE Connect for screen sharing and device integration
  programs.kdeconnect = {
    enable = true;
    # package = pkgs.kdePackages.kdeconnect-kde;
  };

  # Server-side tools only (no x2go or xrdp which are causing the build errors)
  environment.systemPackages = with pkgs; [
    kdePackages.krfb # KDE's built-in desktop sharing application
    x11vnc # VNC server that can be run manually
  ];
}
