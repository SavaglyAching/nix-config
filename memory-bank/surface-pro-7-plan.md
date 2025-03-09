# Surface Pro 7 NixOS Configuration Plan

## Overview

This document outlines the plan for setting up a new NixOS host for a Microsoft Surface Pro 7, including configuration for using a remote builder on the host nixos-desk.

## Directory Structure

```
hosts/
  nixos-surface/
    default.nix         # Main configuration file
    hardware-configuration.nix  # Hardware-specific configuration (generated during installation)
```

## Configuration Files

### 1. Flake.nix Updates

We need to update the flake.nix file to:
- Add the nixos-hardware repository as an input
- Add the new nixos-surface configuration to the outputs

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nixos-hardware.url = "github:NixOS/nixos-hardware/master";
};

outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
  nixosConfigurations = {
    # Existing configurations...
    
    "nixos-surface" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos-surface
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ham = import ./home/ham.nix;
        }
      ];
    };
  };
};
```

### 2. Host Configuration (default.nix)

```nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # System modules
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    
    # Desktop environment - KDE works well with touchscreens
    ../../modules/desktop/kde.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-surface";

  # Surface-specific configurations
  microsoft-surface = {
    ipts.enable = true;  # Enable touchscreen support
    surface-control.enable = true;  # Enable surface control daemon
  };

  # Remote builder configuration
  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "nixos-desk";
      system = "x86_64-linux";
      maxJobs = 8;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }];
  };

  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}
```

### 3. Remote Builder Setup on nixos-desk

We need to update the nixos-desk configuration to accept remote build jobs:

```nix
# Add to hosts/nixos-desk/default.nix
nix.settings.trusted-users = [ "ham" ];
```

## SSH Key Setup for Remote Building

For remote building to work, SSH keys need to be set up. Here are the specific commands to run:

### On nixos-surface (the client machine):

1. Generate SSH keys if they don't exist:
   ```bash
   # Check if keys already exist
   ls -la ~/.ssh/id_ed25519*
   
   # If keys don't exist, generate them (use ed25519 for better security)
   ssh-keygen -t ed25519 -C "surface-remote-builder"
   # Press Enter to accept default location and optionally set a passphrase
   ```

2. Copy the public key to nixos-desk:
   ```bash
   # This will prompt for your password on nixos-desk
   ssh-copy-id ham@nixos-desk
   ```

3. Test the SSH connection:
   ```bash
   # This should connect without asking for a password
   ssh ham@nixos-desk
   ```

4. Configure SSH for easier connections (optional):
   ```bash
   # Create or edit ~/.ssh/config
   nano ~/.ssh/config
   
   # Add the following:
   Host nixos-desk
     HostName nixos-desk
     User ham
     IdentityFile ~/.ssh/id_ed25519
   ```

### On nixos-desk (the builder machine):

1. Ensure the SSH daemon is running:
   ```bash
   # Check SSH service status
   systemctl status sshd
   
   # If not running, start it
   sudo systemctl start sshd
   sudo systemctl enable sshd
   ```

2. Verify the authorized keys were added:
   ```bash
   cat ~/.ssh/authorized_keys
   # Should see the key from nixos-surface
   ```

3. Ensure the nix daemon is configured to allow the user as a trusted user:
   ```bash
   # This is handled by the configuration above, but you can check with:
   grep trusted-users /etc/nix/nix.conf
   ```

## User Configuration for Remote Building

You don't need to create a separate user specifically for builds. The existing user 'ham' can be used for remote building as long as:

1. The user exists on both machines with the same UID
2. The user is added to the trusted-users list on the build machine (nixos-desk)
3. SSH keys are properly set up for passwordless authentication between the machines

The configuration above already adds 'ham' to the trusted-users list on nixos-desk, which is the key requirement for allowing remote builds.

## Installation Process

After creating these configurations:
1. Generate a hardware-configuration.nix during NixOS installation
2. Copy it to the hosts/nixos-surface directory
3. Set up SSH keys for remote building using the commands above
4. Build the system with: `sudo nixos-rebuild switch --flake .#nixos-surface`

## Testing Remote Building

To test that remote building works:
1. Run a build with verbose output: `nix-build -v <some-derivation>`
2. Check that the build is executed on nixos-desk
3. You should see output indicating that the build is happening on the remote machine

## Additional Considerations

- The Surface Pro 7 may require specific kernel parameters for optimal performance
- Power management settings may need to be adjusted for better battery life
- Consider adding hibernation support for the Surface Pro