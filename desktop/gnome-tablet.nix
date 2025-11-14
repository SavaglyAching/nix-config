{ config, lib, pkgs, ... }:

{
  imports = [
    ./gnome.nix
  ];

  # GNOME tablet/touchscreen enhancements for Surface and other touch-enabled devices
  # Provides gesture support, on-screen keyboard, and input method configuration

  # Install GNOME-specific packages that enhance touchscreen experience
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-shell-extensions
    gnome-extension-manager
    touchegg
    libinput
    libinput-gestures
    wev
  ];

  # Enable touchegg service for gesture support
  services.touchegg.enable = true;

  # Enable GNOME's on-screen keyboard explicitly via dconf settings
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/a11y/applications" = {
        screen-keyboard-enabled = true;
      };
      "org/gnome/desktop/a11y" = {
        always-show-universal-access-status = true;
      };
      "org/gnome/desktop/interface" = {
        toolkit-accessibility = true;
      };
    };
  }];

  # Enable input method framework
  # GNOME works better with ibus than fcitx
  i18n.inputMethod = {
    type = "ibus";
    enable = true;
    ibus.engines = with pkgs.ibus-engines; [ typing-booster ];
  };

  # Set environment variables for input methods
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };
}
