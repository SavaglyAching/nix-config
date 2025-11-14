# Asahi Firmware Files

This directory must contain the Asahi peripheral firmware files copied from your Mac's Asahi installation.

## Required Files

- `all_firmware.tar.gz` - Wi-Fi, Bluetooth, and other peripheral firmware
- `kernelcache*` files - Boot firmware

## How to Obtain Firmware

1. **Run the Asahi installer from macOS first** to set up the UEFI environment
2. **Boot into the Asahi installer environment** (after running the Asahi installer from macOS)
3. **Mount the EFI System Partition** (usually already mounted at /boot)
4. **Copy firmware files:**
   ```bash
   cp /boot/asahi/all_firmware.tar.gz ./
   cp /boot/asahi/kernelcache* ./
   ```
5. **Place these files in this directory** before building the NixOS configuration

## What These Files Do

These firmware files are required for:
- Wi-Fi connectivity
- Bluetooth functionality
- Trackpad and keyboard operation
- Touch ID (if supported)
- Other peripheral devices

## Important Notes

- **Hardware-specific**: These files are specific to your Mac model and cannot be distributed in the repository
- **Required for functionality**: Without these files, the system will build but peripherals won't work
- **Pure builds**: This approach keeps the flake build pure and avoids needing the `--impure` flag during `nixos-rebuild`

## Installation Script

The `install-asahi.sh` script will automatically attempt to copy these files from `/boot/asahi/` during installation. If you're building manually, you must copy them yourself before running `nixos-rebuild`.
