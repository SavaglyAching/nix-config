{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    librewolf
    vscode-fhs
    spotify
    stremio
    obsidian
  
  ];

  services.flatpak.enable = true;

}
