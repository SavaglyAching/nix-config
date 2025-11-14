{ config, lib, pkgs, ... }:

{
  # Import desktop packages (only available on x86_64-linux)
  home-manager.users.ham = {
    imports = lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      ../home/desktop-packages.nix
    ];
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [ kdePackages.krdc kdePackages.ffmpegthumbs kdePackages.kdegraphics-thumbnailers];

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";
  };

}
