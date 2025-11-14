# desktop/hyprland.nix
# System-level Hyprland configuration
# User-specific Hyprland settings are configured via Home Manager
{ config, lib, pkgs, ... }:

{

  # Import Hyprland Home Manager configuration
  home-manager.users.ham = {
    imports = [
      ../home/programs/hyprland
    ] ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      ../home/desktop-packages.nix
    ];
  };

  # Enable Hyprland at system level
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portal configuration for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  # Hyprland-specific system packages
  environment.systemPackages = with pkgs; [
    # Idle and lock
    hypridle
    hyprlock

    # Authentication agent
    hyprpolkitagent       # Hyprland's polkit authentication agent
  ];

  # Enable polkit for authentication
  security.polkit.enable = true;

  # Enable greetd for automatic Wayland login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
      initial_session = {
        command = "Hyprland";
        user = "ham";
      };
    };
  };
}
