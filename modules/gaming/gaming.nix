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
    nvtopPackages.amd
    protonup-qt
   # rocm-smi
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
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = ["amdgpu"];
  programs.gamemode.enable = true;

  # Add ROCm packages for GPU compute
  hardware.graphics.extraPackages = with pkgs; [
   # rocm-opencl-icd
  ];
  

  # Extra fonts for compatibility
  fonts.packages = with pkgs; [
    corefonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}
