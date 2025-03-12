{ config, lib, pkgs, ... }:

{
  # KDE Connect for screen sharing and device integration
  programs.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
  
  # X2Go Server for remote desktop sessions
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.x2goserver.enable = true;
  
  # Server-side tools only (no viewer clients)
  environment.systemPackages = with pkgs; [
    kdePackages.krfb  # KDE's built-in desktop sharing application
    x11vnc            # VNC server that can be run manually
  ];
}