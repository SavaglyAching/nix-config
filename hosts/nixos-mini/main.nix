{ config, pkgs, ... }:

{
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.rtkit.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  programs.mosh.enable = true;
  programs.nix-ld.enable = true;

}
