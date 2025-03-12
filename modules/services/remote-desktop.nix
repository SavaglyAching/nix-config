{ config, lib, pkgs, ... }:

{
  # KDE Connect for screen sharing and device integration
  programs.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
  
  # X2Go Server (For remote desktop sessions)
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.x2goserver.enable = true;
  
  # VNC Server (TigerVNC)
  services.tigervnc = {
    enable = true;
    port = 5900;
    autoStart = true;
    depth = 24;
    geometry = "1920x1080";
  };
  
  # Install helpful utilities for remote desktop access
  environment.systemPackages = with pkgs; [
    tigervnc
    x11vnc
    x2goclient
  ];
}