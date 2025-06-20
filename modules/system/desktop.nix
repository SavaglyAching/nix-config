{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    librewolf
    vscode-fhs
    spotify
    stremio
    obsidian
    warp-terminal
    vlc
  ];

  services.flatpak.enable = true;

}
