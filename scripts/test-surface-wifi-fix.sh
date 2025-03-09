#!/bin/bash

# Test script for Surface Pro 7 WiFi connectivity fix
# This script tests each change incrementally to identify which one resolves the issue

set -e

echo "Surface Pro 7 WiFi Connectivity Fix Test Script"
echo "==============================================="
echo

# Function to prompt for continuation
continue_prompt() {
  read -p "Continue to the next step? (y/n): " choice
  case "$choice" in 
    y|Y ) return 0;;
    * ) return 1;;
  esac
}

# Step 1: Build with current changes
echo "Step 1: Building with all current changes"
echo "----------------------------------------"
echo "This will build the configuration with all the changes we've made:"
echo "1. Added NetworkManager and iwd support in network.nix"
echo "2. Updated Surface-specific configuration in nixos-surface/default.nix"
echo "3. Updated flake.nix to use microsoft-surface-pro-intel module"
echo
echo "Running: sudo nixos-rebuild build --flake .#nixos-surface"
sudo nixos-rebuild build --flake .#nixos-surface

echo
echo "Build completed. Now let's test the configuration without switching."
echo

if ! continue_prompt; then
  echo "Exiting test script."
  exit 0
fi

# Step 2: Test without switching
echo
echo "Step 2: Testing without switching"
echo "--------------------------------"
echo "This will activate the configuration temporarily without making it permanent."
echo "You can test if WiFi works in this configuration."
echo
echo "Running: sudo nixos-rebuild test --flake .#nixos-surface"
sudo nixos-rebuild test --flake .#nixos-surface

echo
echo "Test completed. Check if WiFi is working now."
echo "If WiFi is working, you can proceed to switch to this configuration permanently."
echo "If WiFi is still not working, we can try testing individual changes."
echo

if ! continue_prompt; then
  echo "Exiting test script."
  exit 0
fi

# Step 3: Switch to new configuration if it works
echo
echo "Step 3: Switching to new configuration"
echo "-------------------------------------"
echo "This will make the changes permanent if the test was successful."
echo
echo "Running: sudo nixos-rebuild switch --flake .#nixos-surface"
sudo nixos-rebuild switch --flake .#nixos-surface

echo
echo "Switch completed. The new configuration is now active."
echo "If WiFi is working, the issue has been resolved!"
echo "If WiFi is still not working, you can try the troubleshooting steps in memory-bank/surface-wifi-fix-plan.md"
echo

# Make the script executable
chmod +x "$0"