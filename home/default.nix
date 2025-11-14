{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

{
  imports = [
    # Shared configuration for all hosts
    ./users/common.nix

    # Core programs
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/bash.nix
    ./programs/tmux.nix
    ./programs/ssh.nix
    ./programs/helix.nix
    ./programs/nh.nix
    ./programs/kitty.nix
    ./programs/claude-code.nix
    #./programs/kodi.nix
    ./programs/npm.nix
    ./programs/starship.nix
    # Desktop environments imported by system-level desktop configs
    #./programs/hyprland/default.nix
    ./programs/niri/default.nix
    #./programs/xfce.nix

    # Desktop packages imported conditionally by desktop modules
    # ./desktop-packages.nix
  ];

  # Set the home-manager state version
  home.stateVersion = "25.05";

  # Export SOPS secrets as environment variables
  # API key is now readable by user ham (see system/sops.nix)
  home.sessionVariablesExtra = ''
    if [ -f /run/secrets/OPENROUTER_API_KEY ]; then
      export OPENROUTER_API_KEY=$(cat /run/secrets/OPENROUTER_API_KEY)
    fi
    if [ -f /run/secrets/GEMINI_API_KEY ]; then
      export GEMINI_API_KEY=$(cat /run/secrets/GEMINI_API_KEY)
    fi
  '';

  # User-specific packages (migrated from system/packages.nix)
  home.packages = with pkgs; [
    # Shell tools
    zoxide
    fzf
    fd
    eza
    ripgrep
    fastfetch
    lolcat
    cowsay
    fortune
    borgbackup
    nil
    wev # Wayland event viewer for debugging input events
    codex

    tree
    yazi
    bat

    # Development tools
    gitui
    lazygit
    lazydocker
    podman-tui
    zed-editor

    # Terminal and editors
    micro
    tmux

    # Applications
    keepassxc

    # Media tools
    yt-dlp
    gallery-dl
    instaloader
    spotdl

    # Fonts - Nerd Fonts for Waybar icons and terminal
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.iosevka-term-slab
    nerd-fonts.inconsolata-go
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    nerd-fonts.roboto-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.ubuntu-mono
    nerd-fonts.dejavu-sans-mono
    font-awesome # Additional icon coverage for UI elements
  ];
}
