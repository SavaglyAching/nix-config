{ config, pkgs, ... }:

{
  home.username = "ham";
  home.homeDirectory = "/home/ham";
  home.stateVersion = "24.11";

  programs.zsh = {
    enable = true;
    shellAliases = {
      nr = "sudo nixos-rebuild switch";
      nrf = "sudo nixos-rebuild switch --flake .#";
      nm = "cd /etc/nixos";
      nixcfg = "cd /home/ham/Documents/nixos-test";
      m = "sudo micro";
      mm = "sudo micro /home/ham/nixos-config/configuration.nix";
      lzd = "lazydocker";
      lzg = "lazygit";
      htop = "btop";
      df = "ncdu";
      miniterm = "bash /scripts/terminal.sh";
    };
  };

  programs.git = {
    enable = true;
    userName = "git";
    userEmail = "git@bloood.ca";
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