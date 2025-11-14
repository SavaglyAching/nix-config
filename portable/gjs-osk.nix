# portable/gjs-osk.nix
# GJS OSK - On-screen keyboard with full keyboard features
# Includes: Ctrl, Alt, Tab, Esc, F1-F12, Arrow keys, number row
# Repository: https://github.com/Vishram1123/gjs-osk
# Extension: https://extensions.gnome.org/extension/5949/gjs-osk/

{ config, lib, pkgs, ... }:

{
  # Install GJS OSK extension via Home Manager
  home-manager.users.ham = {
    home.packages = with pkgs; [
      gnomeExtensions.gjs-osk
    ];

    # Configure GNOME Shell to enable the extension
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gjs-osk@vishram1123.github.io"
        ];
      };
    };
  };
}
