{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./programs/librewolf/librewolf.nix
  ];

  home.packages = with pkgs; [
    vscode-fhs
    spotify
    obs-studio

    vlc
    signal-desktop
    scrcpy
    discord
    obsidian
    #waydroid-helper
    digikam
  ];
}
