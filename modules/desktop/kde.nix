{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    maliit-keyboard
  ];

  environment.sessionVariables = {
    QT_IM_MODULE = "maliit";
  };
}