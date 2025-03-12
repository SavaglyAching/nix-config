{ config, lib, pkgs, ... }:

{
  # Enable X server
  services.xserver.enable = true;
  
  # Enable XFCE desktop environment
  services.xserver.desktopManager.xfce.enable = true;
  
  # Use LightDM as the display manager (commonly used with XFCE)
  services.xserver.displayManager.lightdm.enable = true;
  
  # Install additional XFCE tools and plugins
  environment.systemPackages = with pkgs; [
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.thunar-archive-plugin
    xfce.thunar-volman
  ];
}