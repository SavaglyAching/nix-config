# Surface Pro 7 WiFi Connectivity Issue - Analysis and Resolution Plan

## Problem Description

When upgrading the nixos-surface flake from NixOS 24.11 to 25.xx (unstable branch), internet connectivity is completely lost from KDE. The system is using WiFi on a Surface Pro 7.

## Potential Causes

Based on the analysis of the configuration files, several potential causes have been identified:

1. **Missing WiFi Configuration**: The network.nix module has firewall settings but no explicit WiFi configuration.
2. **Hardware Module Compatibility**: The nixos-hardware module for Surface devices might need updates for the unstable branch.
3. **KDE Network Manager Issues**: The upgrade to Plasma 6 in the unstable branch might have changed how network connections are managed.
4. **Firmware/Driver Changes**: The unstable branch might require additional firmware for the Surface Pro 7's WiFi hardware.
5. **NetworkManager Configuration**: The NetworkManager service might not be properly configured for the Surface Pro 7.

## Resolution Plan

### 1. Add Explicit WiFi Support

Modify the network.nix module to explicitly enable WiFi support:

```nix
# Add to modules/system/network.nix
networking = {
  # Existing configuration...
  
  # Enable NetworkManager for WiFi management
  networkmanager = {
    enable = true;
    wifi.backend = "iwd";  # Use iwd backend for better WiFi performance
  };
};

# Enable iwd for better WiFi on modern hardware
services.iwd = {
  enable = true;
  settings = {
    General = {
      EnableNetworkConfiguration = false;  # Let NetworkManager handle this
    };
  };
};
```

### 2. Update Surface-Specific Configuration

Add Surface-specific network configuration to the nixos-surface configuration:

```nix
# Add to hosts/nixos-surface/default.nix
# Surface-specific network configuration
hardware.firmware = with pkgs; [ linux-firmware ];  # Ensure all firmware is available

# Ensure NetworkManager is configured for Surface hardware
networking.networkmanager = {
  enable = true;
  wifi.backend = "iwd";
};

# Add user to networkmanager group
users.users.ham.extraGroups = [ "networkmanager" ];
```

### 3. Ensure Proper Hardware Module

Verify that the correct nixos-hardware module is being used for the Surface Pro 7:

```nix
# Update in flake.nix
"nixos-surface" = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/nixos-surface
    nixos-hardware.nixosModules.microsoft-surface-pro-7  # If available, otherwise keep microsoft-surface-common
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ham = import ./home/ham.nix;
    }
  ];
};
```

### 4. Add Fallback Network Configuration

Create a fallback network configuration that will ensure basic connectivity even if NetworkManager fails:

```nix
# Add to hosts/nixos-surface/default.nix
# Fallback network configuration
networking.interfaces.wlp0s20f3 = {  # Confirmed Surface Pro 7 WiFi interface name
  useDHCP = true;
};
```

### 5. Disable Firewall Temporarily

If the issue persists, temporarily disable the firewall to check if it's causing the connectivity issues:

```nix
# Modify in modules/system/network.nix or hosts/nixos-surface/default.nix
networking.firewall.enable = false;  # Temporarily disable for testing
```

## Implementation Strategy

1. **Incremental Changes**: Make one change at a time and test to identify which solution resolves the issue.
2. **Build Without Switching**: Use `nixos-rebuild build` or `nixos-rebuild test` to test changes without permanently switching.
3. **Backup Configuration**: Create a backup of the working 24.11 configuration before making changes.

## Testing Procedure

After implementing each change:

1. Build the configuration with: `sudo nixos-rebuild build --flake .#nixos-surface`
2. Test the configuration without switching: `sudo nixos-rebuild test --flake .#nixos-surface`
3. If WiFi works in test mode, switch to the new configuration: `sudo nixos-rebuild switch --flake .#nixos-surface`

## Troubleshooting Steps

If the issue persists:

1. Check the WiFi interface name with `ip a` and update the fallback configuration accordingly
2. Verify firmware is loaded with `dmesg | grep firmware`
3. Check NetworkManager status with `systemctl status NetworkManager`
4. Look for errors in the journal: `journalctl -u NetworkManager -b`
5. Check if the correct kernel modules are loaded: `lsmod | grep iwl`

## Additional Considerations

1. **Kernel Version**: The unstable branch might use a newer kernel that requires different configuration for the Surface Pro 7's WiFi hardware.
2. **Plasma 6 Integration**: Ensure that KDE Plasma 6 is properly integrated with NetworkManager.
3. **Remote Builder Impact**: Consider if the remote builder configuration is affecting network settings.
4. **Unstable Branch Changes**: The unstable branch may have introduced changes to how network interfaces are managed or how NetworkManager interacts with KDE Plasma 6.

## Understanding the Issue

The loss of internet connectivity when upgrading to the unstable branch could be caused by several factors:

1. **NetworkManager Integration**: In NixOS 25.xx, there might be changes to how NetworkManager integrates with KDE Plasma 6. The unstable branch often includes the latest versions of software, which can sometimes introduce compatibility issues.

2. **Firmware/Driver Changes**: The Surface Pro 7 uses Intel WiFi hardware (likely an Intel AX201 or similar), which requires specific firmware. The unstable branch might include updated firmware packages or kernel modules that need additional configuration.

3. **KDE Plasma 6 Changes**: KDE Plasma 6 is a major update from Plasma 5, and there might be changes to how network connections are managed in the desktop environment.

4. **Module Compatibility**: The nixos-hardware module for Surface devices might need updates to work correctly with the unstable branch.

To better understand what's happening, you can check the following after building with the unstable branch (if you can get a wired connection):

```bash
# Check NetworkManager status
systemctl status NetworkManager

# Check if WiFi interface is recognized
ip a

# Check kernel messages for WiFi-related issues
dmesg | grep -i wifi
dmesg | grep -i iwl

# Check if NetworkManager can see WiFi networks
nmcli device wifi list

# Check if the WiFi interface is managed by NetworkManager
nmcli device status
```

## Rollback Plan

If none of the solutions work, a rollback plan is needed:

1. Boot into the previous generation using the GRUB menu
2. Switch back to the 24.11 branch: `sudo nixos-rebuild switch --flake .#nixos-surface`
3. Pin the nixpkgs input to a specific commit that is known to work

## Step-by-Step Implementation Instructions

Follow these steps to implement the changes:

### Step 1: Update network.nix

1. Edit the file: `modules/system/network.nix`
2. Add NetworkManager and iwd configuration:

```nix
{ config, lib, pkgs, ... }:

{
  networking = {
    # Hostname is set in the host-specific configuration

    
    # Firewall settings
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 41641 ]; # Tailscale port
      allowPing = false;
      trustedInterfaces = [ "tailscale0" ];
      
      # Extra rules for remote builder
      extraCommands = ''
        # Allow all connections from the Surface device for Nix remote building
        iptables -A INPUT -p tcp -s 192.168.2.0/24 --dport 22 -j ACCEPT
      '';
    };
    
    # Enable NetworkManager for WiFi management
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";  # Use iwd backend for better WiFi performance
    };
  };
  
  # Enable iwd for better WiFi on modern hardware
  services.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = false;  # Let NetworkManager handle this
      };
    };
  };
}
```

### Step 2: Update Surface-Specific Configuration

1. Edit the file: `hosts/nixos-surface/default.nix`
2. Add the Surface-specific network configuration:

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
    ../../modules/system/remote-builder.nix
    
    # Desktop environment - KDE works well with touchscreens
    ../../modules/desktop/kde.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-surface";
  
  # Surface-specific network configuration
  hardware.firmware = with pkgs; [ linux-firmware ];  # Ensure all firmware is available

  # Ensure NetworkManager is configured for Surface hardware
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  
  # Fallback network configuration with correct interface name
  networking.interfaces.wlp0s20f3 = {
    useDHCP = true;
  };

  # Add user to networkmanager group
  users.users.ham.extraGroups = [ "networkmanager" ];

  # Surface-specific configurations
  # The nixos-hardware module already includes the necessary configurations
  # for Surface devices, so we don't need to explicitly enable features here.
  # If specific options are needed, they can be added after consulting the
  # nixos-hardware documentation.
  
  # Enable remote builder
  services.remote-builder = {
    enable = true;
    isBuilder = false;
    builderUser = "ham";
    sshKeyPath = "/home/ham/.ssh/surface-remote-builder";  # Use the specific key for Surface
    builderIP = "192.168.2.254";
    maxJobs = 24;
  };

  # Enable libinput for better touchscreen and touchpad support

  # Ensure Tailscale is enabled for remote builder connection
  services.tailscale.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Remote builder configuration using Tailscale
  time.timeZone = "America/Moncton";
  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}
```

### Step 3: Check and Update Hardware Module

1. Check if a specific Surface Pro 7 module exists in the nixos-hardware repository:
   ```bash
   nix flake show github:NixOS/nixos-hardware
   ```

2. If a specific Surface Pro 7 module exists, update `flake.nix`:
   ```nix
   "nixos-surface" = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [
       ./hosts/nixos-surface
       nixos-hardware.nixosModules.microsoft-surface-pro-7  # Use specific module if available
       home-manager.nixosModules.home-manager
       {
         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.users.ham = import ./home/ham.nix;
       }
     ];
   };
   ```

### Step 4: Test the Changes

1. Build without switching:
   ```bash
   sudo nixos-rebuild build --flake .#nixos-surface
   ```

2. Test the configuration:
   ```bash
   sudo nixos-rebuild test --flake .#nixos-surface
   ```

3. If WiFi works, switch to the new configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos-surface
   ```

### Step 5: Troubleshooting

If WiFi still doesn't work:

1. Check NetworkManager status:
   ```bash
   systemctl status NetworkManager
   ```

2. Check for firmware issues:
   ```bash
   dmesg | grep firmware
   ```

3. Check loaded kernel modules:
   ```bash
   lsmod | grep iwl
   ```

4. Temporarily disable the firewall:
   ```nix
   # In hosts/nixos-surface/default.nix
   networking.firewall.enable = false;
   ```