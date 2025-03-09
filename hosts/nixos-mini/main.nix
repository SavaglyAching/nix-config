{ config, pkgs, ... }:

{
  
  environment.systemPackages = with pkgs; [
    alacritty
    btop
    btrfs-progs
    curl
    docker-compose
    ffmpeg-full
    frigate
    gallery-dl
    git
    glow
    gitui
    rclone-browser
    htop
    instaloader
    temurin-jre-bin-21
    lazygit
    lazydocker
    mc
    mesa
    micro
    mosh
    neovim
    nmap
    intel-gpu-tools
    rclone
    spotdl
    tmux
    trayscale
    unzip
    vscode
    wget
    yt-dlp
    zip
  ];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.rtkit.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  programs.mosh.enable = true;
  programs.nix-ld.enable = true;

    programs.bash = {
      shellAliases = {
        nr = "sudo nixos-rebuild switch";
        nm = "cd /etc/nixos";
        mm = "sudo micro /etc/nixos/main.nix";
        m = "sudo micro";
        lzd = "lazydocker";
        miniterm = "bash /scripts/terminal.sh";
      };
    };

  environment.etc."gitconfig".text = ''
    [user]
      name = ham
      email = git@bloood.ca
  '';
}
