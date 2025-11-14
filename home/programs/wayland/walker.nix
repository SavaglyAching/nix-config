{ pkgs, ... }:

{
  services.walker = {
    enable = true;
    systemd.enable = true;

    # Walker configuration
    # Wayland-native application launcher
    settings = {
      # Basic configuration to initialize walker
      search.placeholder = "Search...";
    };
  };
}
