{
  config,
  pkgs,
  stable,
  ...
}:

{
  # Import game-specific modules
  imports = [
    ./games/ksp.nix
  ];
  # Allow unfree packages for things like Steam
  nixpkgs.config.allowUnfree = true;
  # Add gaming packages
  environment.systemPackages = with pkgs; [
    steam-run
    winetricks
    protonup-qt # GUI for managing Proton-GE
    gamescope
    rpcs3
    # Wayland compositor for gaming
  ];

  # Enable gamescope with CAP_SYS_NICE for better performance
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Enable and configure Steam with all recommended options
  programs.steam = {
    enable = true;
    # Pin Steam to nixos-25.05 channel to avoid crashes
    package = stable.steam;

    # Firewall configurations for better functionality
    remotePlay.openFirewall = false; # Steam Remote Play
    dedicatedServer.openFirewall = false; # Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # LAN game transfers

    # Add Proton-GE for better game compatibility
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Hardware acceleration for Steam (already in amd.nix but ensure 32-bit)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable Steam hardware support (controllers, VR, etc.)
  hardware.steam-hardware.enable = true;

  # Enable gamemode daemon for performance optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  # Extra fonts for compatibility
  fonts.packages = with pkgs; [
    corefonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
