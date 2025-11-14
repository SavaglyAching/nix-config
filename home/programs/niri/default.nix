{ pkgs, config, ... }:

{
  imports = [
    ../wayland/default.nix
  ];

  # Session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable Wayland support in Electron apps
    MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland in Firefox/LibreWolf
  };

  # Niri configuration using out-of-store symlink for editability
  xdg.configFile."niri/config.kdl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/programs/niri/config.kdl";
  };
}
