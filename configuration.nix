{ config, pkgs, ... }:

{
  # Basic system configuration
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader, networking, etc. (keep your existing configuration)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-desk";  # Use your remote builder's hostname
  networking.networkmanager.enable = true;

  # User configuration with SSH key for remote building
  users.users.ham = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [
      # Your existing keys
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqNpQzPXCgbUM3EA99GXlfeL8nnDDhJEqH+ZzLy84GO j@deskv"
      # Surface remote builder key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5ryKKKc1NZBKj/wXIQynMvcIGQ0knE/hXfc+d4UCMn surface-remote-builder"
    ];
  };

  # Nix configuration for remote building
  nix = {
    settings = {
      trusted-users = [ "ham" ];  # Important: this allows ham to perform builds
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # SSH server configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
    };
    extraConfig = ''
      # Allow TCP forwarding for Nix remote builds
      AllowTcpForwarding yes
    '';
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH port
    
    # Allow connections from your Surface device
    extraCommands = ''
      # Allow all connections from the Surface device for Nix remote building
      iptables -A INPUT -p tcp -s 192.168.2.0/24 --dport 22 -j ACCEPT
    '';
  };

  # Tailscale (if you're using it)
  services.tailscale.enable = true;

  # Your other configuration options...
  
  # System state version
  system.stateVersion = "24.11";  # Use your current stateVersion
}
