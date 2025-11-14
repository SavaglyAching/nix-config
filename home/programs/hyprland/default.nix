{ pkgs, ... }:

{
  imports = [
    ./hyprland-settings.nix
    ./keybindings.nix
    ../wayland
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };
}
