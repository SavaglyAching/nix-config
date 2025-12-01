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

    # Discord with Wayland flags to fix GPU crashes
    (discord.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
      postFixup = (oldAttrs.postFixup or "") + ''
        wrapProgram $out/bin/discord \
          --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations" \
          --add-flags "--ozone-platform=wayland"
      '';
    }))

    obsidian
    #waydroid-helper
    digikam
  ];
}
