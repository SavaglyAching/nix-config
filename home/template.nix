{ config, pkgs, ... }:

{
  # Replace with actual username and home directory
  home.username = "username";
  home.homeDirectory = "/home/username";
  home.stateVersion = "24.11"; # Do not change after initial setup

  # Shell configuration
  programs.zsh = {
    enable = true;
    shellAliases = {
      # NixOS management
      nr = "sudo nixos-rebuild switch";
      nrf = "sudo nixos-rebuild switch --flake .#";
      
      # Add your custom aliases here
    };
    # Uncomment to enable additional zsh features
    # enableAutosuggestions = true;
    # enableSyntaxHighlighting = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    # Additional git configuration
    # extraConfig = {
    #   init.defaultBranch = "main";
    # };
  };

  # User packages
  home.packages = with pkgs; [
    # Terminal utilities
    btop
    htop
    ncdu
    
    # Development tools
    git
    
    # Add more packages as needed
  ];
  
  # Additional program configurations
  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs.vscode-extensions; [
  #     # Add extensions here
  #   ];
  # };
}