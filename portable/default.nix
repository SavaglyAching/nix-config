# portable/default.nix
# Main configuration module for portable/tablet devices
# Import this module for Surface, laptops, and other portable devices

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./gjs-osk.nix
    ./power-management.nix
    ./sensors.nix
  ];
}
