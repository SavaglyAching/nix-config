{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Idle management - Hyprland-specific
  # TODO: Add compositor-agnostic idle management (swayidle) or make conditional
  services.hypridle = {
    enable = lib.mkDefault false; # Disabled by default, enable in Hyprland config
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
