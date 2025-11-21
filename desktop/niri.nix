# desktop/niri.nix
# System-level Niri configuration
# User-specific Niri settings are configured via Home Manager
{
  config,
  lib,
  pkgs,
  ...
}:

let
  tuigreetCmd = command: "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${command}";
in
{
  # System packages required for Niri
  environment.systemPackages = with pkgs; [
    xwayland-satellite # XWayland support for legacy X11 apps (Steam, etc.)
  ];

  # Import desktop packages (only available on x86_64-linux)
  home-manager.users.ham = {
    imports = lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      ../home/desktop-packages.nix
    ];
  };

  # Enable Niri at system level
  programs.niri.enable = true;

  # PipeWire audio stack with compatibility layers
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = false;
  };

  security.rtkit.enable = true;

  # XDG Desktop Portal configuration optimised for Niri
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };

      "org.freedesktop.impl.portal.ScreenCast" = {
        default = [ "gnome" ];
      };

      "org.freedesktop.impl.portal.Screenshot" = {
        default = [ "gnome" ];
      };

      "org.freedesktop.impl.portal.Secret" = {
        default = [ "gnome-keyring" ];
      };

      "org.freedesktop.impl.portal.FileChooser" = {
        default = [ "gtk" ];
      };
    };
  };

  # PAM configuration for hyprlock
  security.pam.services.hyprlock = {};

  # Enable polkit for authentication prompts
  security.polkit.enable = true;

  # Secret portal implementation via GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # Wayland display manager using greetd + tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = tuigreetCmd "niri-session";
        user = "ham";
      };
      initial_session = {
        command = "niri-session";
        user = "ham";
      };
    };
  };
}
