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
  
  # VNC Server (using x11vnc)
  services.x11vnc = {
    enable = true;
    auth = null;
    autoStart = true;
    port = 5900;
    xkbLayout = "us";
    shared = true;
    viewonly = false;
  };
  
  # Remote desktop tools
  environment.systemPackages = with pkgs; [
    kdePackages.krfb  # KDE's desktop sharing application
    x11vnc
    x2goclient
  ];
}