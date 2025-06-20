{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    librewolf
    vscode-fhs
    spotify
    stremio
    obsidian
    warp-terminal
  
  ];

  services.flatpak.enable = true;

}
