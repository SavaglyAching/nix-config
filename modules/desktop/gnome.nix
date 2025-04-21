# modules/desktop/gnome.nix
{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  
  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Enable GNOME's accessibility features (including on-screen keyboard)
  services.gnome.core-os-services.enable = true;
  services.gnome.core-utilities.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  
  # Enable GNOME's on-screen keyboard explicitly
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.a11y.applications]
    screen-keyboard-enabled=true
    
    [org.gnome.desktop.a11y]
    always-show-universal-access-status=true
    
    [org.gnome.desktop.interface]
    toolkit-accessibility=true
  '';
  
  # Install GNOME-specific packages that enhance touchscreen experience
  environment.systemPackages = with pkgs; [
    pkgs.gnome-tweaks
    pkgs.gnome-shell-extensions
    gnome-extension-manager
    touchegg
    libinput
    libinput-gestures
    wev
  ];
  
  # Enable touchegg service for gesture support
  services.touchegg.enable = true;
  
  # Enable input method framework
  i18n.inputMethod = {
    enabled = "ibus";  # GNOME works better with ibus than fcitx
    ibus.engines = with pkgs.ibus-engines; [
      typing-booster
    ];
  };
  
  # Set environment variables for input methods
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };
}
