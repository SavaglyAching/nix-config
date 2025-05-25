{ config, lib, pkgs, ... }:

{
  # Shell and Terminal Configuration
  programs = {
    # ZSH Configuration
    zsh = {
      enable = true;
      autosuggestions.enable = true;
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
        htop = "btop"; # btop is a better htop
        df = "ncdu"; # ncdu is a better df
        
        # Misc
        miniterm = "bash /scripts/terminal.sh";
      };

        initExtra = ''
    # Your Zsh function goes here, exactly as it would in .zshrc
    yt() {
        yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 60 "$@"
    }

    # You can add other functions or Zsh commands here too
    # another_func() {
    #   echo "Hello from Zsh initExtra"
    # }
  '';
    };
    
    # TMUX Configuration
    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];
    };
    
    # Mosh Terminal
    mosh.enable = true;
  };
}