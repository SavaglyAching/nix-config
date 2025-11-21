{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  imports = lib.optionals (osConfig.programs.niri.enable or false) [
    ./waybar.nix
    ./hypridle.nix
    ./walker.nix
    ./mako.nix
    ../hyprpaper.nix
  ];

  home.sessionVariables = lib.mkIf (osConfig.programs.niri.enable or false) {
    XDG_SESSION_TYPE = "wayland";
  };

  # Common Wayland utilities for all compositors
  home.packages = lib.optionals (osConfig.programs.niri.enable or false) (with pkgs; [
    # Application launcher
    walker

    # Notifications
    mako

    # Wallpaper
    hyprpaper

    # Screenshots
    flameshot
    wl-clipboard-rs

    # Session management
    hypridle # Idle management
    hyprlock # Screen locker

    # System utilities
    pavucontrol # Audio control
    brightnessctl # Brightness control
    networkmanagerapplet # Network manager GUI
    blueman # Bluetooth manager
    wlogout # Logout/power menu for Wayland
    nautilus # GNOME Files manager
  ]);
}
