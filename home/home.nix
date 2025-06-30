{ config, pkgs, ... }:

{
  # This is the primary entry point for the user "ham"
  home-manager.backupFileExtension = "bak";
  home-manager.users.ham = {
    # home.nix options
    home.username = "ham";
    home.homeDirectory = "/home/ham";
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    # Contents from git.nix
    programs.git = {
      enable = true;
      userName = "git";
      userEmail = "git@bloood.ca";
    };

    # Contents from packages.nix
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

    # Contents from shell.nix
    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        shellAliases = {
          # NixOS management
          nr = "sudo nixos-rebuild switch";
          nrf = "sudo nixos-rebuild switch --flake .#";
          nm = "cd /etc/nixos";
          nixcfg = "cd /home/ham/Documents/nixos-test";
          # Editor shortcuts
          m = "sudo micro";
          mm = "sudo micro /home/ham/nixos-config/configuration.nix";
          # Docker management
          lzd = "lazydocker";
          lzg = "lazygit";
          # System monitoring
          htop = "btop";
          df = "ncdu";
          ttdl = "yt-dlp -o '/home/ham/ttdl/%(upload_date)s - %(title)s by %(uploader)s.%(ext)s' -a /home/ham/ttdl/urls.txt --download-archive /home/ham/ttdl/archive.txt";
          yt = "yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 90 --no-part ";
          # Misc
          miniterm = "bash /scripts/terminal.sh";
        };
      };

      tmux = {
        enable = true;
        plugins = with pkgs; [
          tmuxPlugins.better-mouse-mode
        ];
      };
    };

    # Contents from ssh.nix
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/github";
        };
      };
    };
  };
}