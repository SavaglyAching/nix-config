{ config, pkgs, ... }:

{
  # Allow unfree packages for things like Steam
  nixpkgs.config.allowUnfree = true;

  # Add gaming packages
  environment.systemPackages = with pkgs; [
    # gamemode
    lutris
    steam
    steam-run
    winetricks
  ];

  # Enable and configure Steam
  programs.steam = {
    enable = true;
   # remotePlay.openFirewall = true;
   # dedicatedServer.openFirewall = true;
  };

  # Enable gamemode daemon
  # programs.gamemode.enable = true;

  # Enable 32-bit graphics support for Wine and older games
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Extra fonts for compatibility
  fonts.packages = with pkgs; [
    corefonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    tahoma
    tahoma-bold
  ];
}