{ config, lib, pkgs, ... }:

{
  # System Packages
  environment = {
    systemPackages = with pkgs; [
      # Terminal and system tools
      btop
      htop
      ncdu
      mc
      micro
      tmux
      mosh
      
      # System administration
      btrfs-progs
      nmap
      iotop
      dnsutils
       
      # File management and utilities
      curl
      wget
      fzf
      ripgrep
      fd
      tree
      
      # Development tools
      git
      gitui
      lazygit
      lazydocker
      python3
      aider-chat
      keepassxc
      
      # Media tools
      ffmpeg-full
      gallery-dl
      instaloader
      spotdl
      yt-dlp

    ];
    
    pathsToLink = [ "/share/zsh" ];
    
  };
}
