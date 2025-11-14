# modules/desktop/gnome.nix
{ config, lib, pkgs, ... }:

{
  # Import desktop packages (only available on x86_64-linux)
  home-manager.users.ham = {
    imports = lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      ../home/desktop-packages.nix
    ];
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable power-profiles-daemon (conflicts with auto-cpufreq on portable devices)
  services.power-profiles-daemon.enable = lib.mkForce false;

  # Enable GNOME's core services and applications
  services.gnome.core-os-services.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
}
