# NixOS Configuration for Microsoft Surface Pro 7

This directory contains the NixOS configuration for a Microsoft Surface Pro 7 with remote building capabilities using Tailscale.

## Features

- Surface-specific hardware support via nixos-hardware
- Enhanced touchscreen and touchpad support via libinput
- Remote building using nixos-desk as a builder over Tailscale
- KDE Plasma desktop environment optimized for touchscreens

## Installation

1. Boot into the NixOS installation media on your Surface Pro 7
2. Perform the standard NixOS installation steps
3. Generate the hardware configuration:
   ```bash
   nixos-generate-config --root /mnt
   ```
4. Copy the generated hardware-configuration.nix to this directory, replacing the placeholder file

## Tailscale Setup for Remote Building

This configuration uses Tailscale for secure communication between nixos-surface and the remote builder (nixos-desk). Follow these steps to set up the connection:

1. Ensure both machines are running and have the NixOS configuration applied:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos-desk   # On the desk machine
   sudo nixos-rebuild switch --flake .#nixos-surface # On the Surface Pro 7
   ```

2. Log in to Tailscale on both machines:
   ```bash
   sudo tailscale up
   ```

3. Verify the connection by pinging between the machines using their Tailscale hostnames:
   ```bash
   # On nixos-surface
   ping nixos-desk.tailnet-name.ts.net
   ```

4. Update the Tailscale hostname in the configuration:
   - Edit `hosts/nixos-surface/default.nix`
   - Replace `nixos-desk.tailnet-name.ts.net` with your actual Tailscale hostname for nixos-desk
   - Rebuild the configuration

## Testing Remote Building

To test that remote building works:

1. Run a build with verbose output:
   ```bash
   nix-build -v <some-derivation>
   ```

2. Check that the build is executed on nixos-desk
   - You should see output indicating that the build is happening on the remote machine
   - The build artifacts will be copied back to nixos-surface

## Troubleshooting

If remote building doesn't work:

1. Ensure both machines are connected to Tailscale:
   ```bash
   tailscale status
   ```

2. Verify that SSH works over Tailscale:
   ```bash
   ssh ham@nixos-desk.tailnet-name.ts.net
   ```

3. Check that the 'ham' user is in the trusted-users list on nixos-desk:
   ```bash
   grep trusted-users /etc/nix/nix.conf
   ```

4. Ensure the Tailscale hostname is correct in the configuration

## Notes

- The hardware-configuration.nix file in this directory is a placeholder and must be replaced with the actual hardware configuration generated during installation
- The nixos-hardware module for Microsoft Surface devices already includes optimizations for the Surface Pro 7
- Additional Surface-specific options can be added after consulting the nixos-hardware documentation
- Power management settings may need to be adjusted for better battery life