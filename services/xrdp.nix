{ config, lib, pkgs, ... }:

{
  # XRDP remote desktop server for RDP access
  # Access via Tailscale VPN only (no public firewall ports)

  # Enable XFCE desktop environment for XRDP sessions
  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
  };

  # Configure XRDP service
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.xfce.xfce4-session}/bin/startxfce4";

    # Do not open firewall - access via Tailscale only
    openFirewall = false;
  };

  # XRDP uses port 3389 internally (accessible via Tailscale only)
  # Default RDP port: TCP 3389
}
