#!/usr/bin/env bash
# Script to mount BTRFS, nixos-enter, and rebuild host rica
# Usage: sudo ./mount-and-rebuild-rica.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
   exit 1
fi

# Configuration - adjust these as needed
MOUNT_POINT="/mnt"
BTRFS_DEVICE=""  # Will be detected or prompted
BOOT_DEVICE=""   # Will be detected or prompted

echo -e "${GREEN}=== NixOS Rica Mount and Rebuild Script ===${NC}"

# Detect BTRFS devices
echo -e "\n${YELLOW}Detecting BTRFS devices...${NC}"
mapfile -t BTRFS_DEVICES < <(lsblk -nlo NAME,FSTYPE | awk '$2=="btrfs" {print "/dev/"$1}')

if [ ${#BTRFS_DEVICES[@]} -eq 0 ]; then
    echo -e "${RED}No BTRFS devices found!${NC}"
    exit 1
elif [ ${#BTRFS_DEVICES[@]} -eq 1 ]; then
    BTRFS_DEVICE="${BTRFS_DEVICES[0]}"
    echo -e "${GREEN}Found BTRFS device: $BTRFS_DEVICE${NC}"
else
    echo -e "${YELLOW}Multiple BTRFS devices found:${NC}"
    select device in "${BTRFS_DEVICES[@]}"; do
        BTRFS_DEVICE="$device"
        break
    done
fi

# Detect boot partition (usually the first partition)
BOOT_CANDIDATES=$(lsblk -nlo NAME,FSTYPE | awk '$2=="vfat" {print "/dev/"$1}')
if [ -n "$BOOT_CANDIDATES" ]; then
    mapfile -t BOOT_ARRAY <<< "$BOOT_CANDIDATES"
    if [ ${#BOOT_ARRAY[@]} -eq 1 ]; then
        BOOT_DEVICE="${BOOT_ARRAY[0]}"
        echo -e "${GREEN}Found boot partition: $BOOT_DEVICE${NC}"
    else
        echo -e "${YELLOW}Multiple boot partitions found:${NC}"
        select device in "${BOOT_ARRAY[@]}" "Skip"; do
            if [ "$device" != "Skip" ]; then
                BOOT_DEVICE="$device"
            fi
            break
        done
    fi
fi

# Unmount if already mounted
echo -e "\n${YELLOW}Unmounting if already mounted...${NC}"
umount -R "$MOUNT_POINT" 2>/dev/null || true

# Mount BTRFS root
echo -e "\n${YELLOW}Mounting BTRFS root...${NC}"
mkdir -p "$MOUNT_POINT"
mount -o subvol=@root "$BTRFS_DEVICE" "$MOUNT_POINT"
echo -e "${GREEN}Mounted root at $MOUNT_POINT${NC}"

# Mount BTRFS subvolumes if they exist
echo -e "\n${YELLOW}Checking for BTRFS subvolumes...${NC}"
if btrfs subvolume list "$MOUNT_POINT" | grep -q "@home"; then
    echo "Mounting @home subvolume..."
    mkdir -p "$MOUNT_POINT/home"
    mount -o subvol=@home "$BTRFS_DEVICE" "$MOUNT_POINT/home"
fi

if btrfs subvolume list "$MOUNT_POINT" | grep -q "@nix"; then
    echo "Mounting @nix subvolume..."
    mkdir -p "$MOUNT_POINT/nix"
    mount -o subvol=@nix "$BTRFS_DEVICE" "$MOUNT_POINT/nix"
fi

# Mount boot partition
if [ -n "$BOOT_DEVICE" ]; then
    echo -e "\n${YELLOW}Mounting boot partition...${NC}"
    mkdir -p "$MOUNT_POINT/boot"
    mount "$BOOT_DEVICE" "$MOUNT_POINT/boot"
    echo -e "${GREEN}Mounted boot partition${NC}"
fi

# Display mounted filesystems
echo -e "\n${GREEN}Current mount status:${NC}"
mount | grep "$MOUNT_POINT"

# Ask for confirmation before entering chroot
echo -e "\n${YELLOW}Ready to enter NixOS environment and rebuild rica.${NC}"
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted by user${NC}"
    exit 1
fi

# Enter NixOS and rebuild
echo -e "\n${GREEN}Entering NixOS environment...${NC}"

# nixos-enter will handle mounting /dev, /proc, /sys automatically
# Run the rebuild inside the chroot
nixos-enter --root "$MOUNT_POINT" -c "cd /home/ham/nix-config && nixos-rebuild switch --flake .#rica"

echo -e "\n${GREEN}=== Rebuild complete! ===${NC}"
echo -e "${YELLOW}To unmount: sudo umount -R $MOUNT_POINT${NC}"
