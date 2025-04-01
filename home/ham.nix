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

  programs.ssh = {
  enable = true;
  matchBlocks = {
    "github.com" = {
      identityFile = "~/.ssh/github";
    };
  };
};



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
    ffmpeg-full
    gallery-dl
    instaloader
    spotdl
    yt-dlp
  ];
}
