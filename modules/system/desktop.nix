{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    librewolf
    vscode-fhs
    spotify
    stremio
    obs-studio
    vlc
    playwright
    windsurf
    signal-desktop
    vdhcoapp
    brave
  ];
}
