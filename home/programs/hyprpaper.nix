{ config, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${config.home.homeDirectory}/nix-config/home/wallpapers/P1231560.jpg"
        "${config.home.homeDirectory}/nix-config/home/wallpapers/tahoe-beach-night.jpeg"
      ];
      wallpaper = [
        ",${config.home.homeDirectory}/nix-config/home/wallpapers/P1231560.jpg"
      ];
    };
  };
}
