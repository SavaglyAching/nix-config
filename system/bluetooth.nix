{ config, pkgs, ... }:

{
  # Enable Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable Bluetooth manager GUI
  services.blueman.enable = true;
}
