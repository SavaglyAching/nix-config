{ config, pkgs, ... }:

{
  home.username = "ham";
  home.homeDirectory = "/home/ham";
  home.stateVersion = "24.11";

  programs.git = {
    enable = true;
    userName = "git";
    userEmail = "git@bloood.ca";
  };

  # Use home.file to create custom KDE shortcut
  home.file.".config/kglobalshortcutsrc".text = ''
    [org.kde.kdeconnect.daemon]
    show-virtual-keyboard=Meta+K,none,Show Virtual Keyboard
  '';

  # Configure fcitx5 for the user
  home.file.".config/fcitx5/config".text = ''
    [Keyboard]
    NumLock=False

    [Hotkey]
    TriggerKeys=
    EnumerateWithTriggerKeys=True
    AltTriggerKeys=
    EnumerateForwardKeys=
    EnumerateBackwardKeys=
    EnumerateSkipFirst=False
    EnumerateGroupForwardKeys=
    EnumerateGroupBackwardKeys=
  '';

  home.packages = with pkgs; [
    btop
    htop
    ncdu
    mc
    micro
    tmux
    mosh
    btrfs-progs
    nmap
    iotop
    dnsutils
    curl
    wget
    fzf
    ripgrep
    fd
    tree
    git
    gitui
    lazygit
    lazydocker
    python3
    aider-chat
    keepassxc
    ffmpeg-full
    gallery-dl
    instaloader
    spotdl
    yt-dlp
    vscode-fhs
    firefox
    librewolf
  ];
}
