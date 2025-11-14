#!/usr/bin/env bash
# Quick script to unmount rica
# Usage: sudo ./unmount-rica.sh

set -e

MOUNT_POINT="/mnt"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Unmounting $MOUNT_POINT..."
umount -R "$MOUNT_POINT" 2>/dev/null || {
    echo "Nothing mounted at $MOUNT_POINT or already unmounted"
    exit 0
}

echo "Successfully unmounted $MOUNT_POINT"
