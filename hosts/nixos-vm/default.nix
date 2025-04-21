{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/desktop/kde.nix
    ../../modules/services/ssh.nix
    ../../modules/services/docker.nix
  ];

  # VM-specific configuration
  networking.hostName = "nixos-vm";
  
  # VirtualBox guest additions
  virtualisation.virtualbox.guest.enable = true;
  
  # VM-specific boot configuration
  boot.loader = {
    # Use GRUB with MBR for VirtualBox VMs
    grub = {
      enable = true;
      device = "/dev/sda";
      efiSupport = false;
      useOSProber = true;
    };
    # Disable EFI for VirtualBox VM
    efi.canTouchEfiVariables = false;
  };
  
  # Shared folders configuration
  fileSystems."/shared" = {
    fsType = "vboxsf";
    device = "shared";
    options = [ "rw" "nofail" ];
  };
  
  # Development environment packages
  environment.systemPackages = with pkgs; [
    # Development tools
    vscode
    git
    gitui
    lazygit

    
    # Additional development tools
    nodejs
    python3
    python3Packages.pip
    gcc
    gnumake
  ];
  
  # Enable Docker for development
  virtualisation.docker.enable = true;
  
  
  # System state version
  system.stateVersion = "24.11";
}