{ pkgs, config, lib, osConfig, ... }:

{
  imports = [
    ../wayland/default.nix
  ];

  # Session variables
  home.sessionVariables = lib.mkIf (osConfig.programs.niri.enable or false) {
    NIXOS_OZONE_WL = "1"; # Enable Wayland support in Electron apps
    MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland in Firefox/LibreWolf
  };

  # Niri configuration using out-of-store symlink for editability
  xdg.configFile."niri/config.kdl" = lib.mkIf (osConfig.programs.niri.enable or false) {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/programs/niri/config.kdl";
  };
}
