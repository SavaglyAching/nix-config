{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    onboard
    florence
    maliit-keyboard
    maliit-framework
    fcitx5
    fcitx5-configtool
    fcitx5-gtk
    fcitx5-with-addons
  ];

  # Enable input method
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  # SDDM configuration for virtual keyboard
  services.xserver.displayManager.sddm.settings = {
    General = {
      InputMethod = "qtvirtualkeyboard";
    };
  };

  # Ensure libinput is enabled for touch events
  services.xserver.libinput = {
    enable = true;
    # Improve touch behavior
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      disableWhileTyping = true;
    };
  };
}
