{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    librewolf
    vscode-fhs
    spotify
    stremio
    obs-studio
    vlc
    signal-desktop
    scrcpy
  ];
}
