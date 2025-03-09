#!/bin/bash
# Script to test and troubleshoot remote builder connections

# Default values
REMOTE_IP="192.168.2.254"
SSH_USER="ham"
SSH_KEY="/home/ham/.ssh/id_ed25519"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --ip)
      REMOTE_IP="$2"
      shift 2
      ;;
    --user)
      SSH_USER="$2"
      shift 2
      ;;
    --key)
      SSH_KEY="$2"
      shift 2
      ;;
    --surface)
      SSH_KEY="/home/ham/.ssh/surface-remote-builder"
      shift
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --ip IP        Remote IP address (default: 192.168.2.254)"
      echo "  --user USER    SSH user (default: ham)"
      echo "  --key PATH     SSH key path (default: /home/ham/.ssh/id_ed25519)"
      echo "  --surface      Use Surface-specific SSH key (/home/ham/.ssh/surface-remote-builder)"
      echo "  --help         Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

echo "Testing remote builder connection..."
echo "Remote IP: $REMOTE_IP"
echo "SSH User: $SSH_USER"
echo "SSH Key: $SSH_KEY"
echo

# Check if SSH key exists
if [[ ! -f "$SSH_KEY" ]]; then
  echo "ERROR: SSH key not found at $SSH_KEY"
  echo "Would you like to generate a new key? (y/n)"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    ssh-keygen -t ed25519 -f "$SSH_KEY"
    echo "Key generated. Now copying to remote host..."
    ssh-copy-id -i "${SSH_KEY}.pub" "${SSH_USER}@${REMOTE_IP}"
  else
    echo "Please provide a valid SSH key path and try again."
    exit 1
  fi
fi

# Check SSH key permissions
KEY_PERMS=$(stat -c "%a" "$SSH_KEY")
if [[ "$KEY_PERMS" != "600" ]]; then
  echo "WARNING: SSH key has incorrect permissions: $KEY_PERMS (should be 600)"
  echo "Fixing permissions..."
  chmod 600 "$SSH_KEY"
fi

# Test basic SSH connection
echo "Testing SSH connection..."
if ssh -i "$SSH_KEY" -o ConnectTimeout=5 "${SSH_USER}@${REMOTE_IP}" "echo Connection successful"; then
  echo "✅ SSH connection successful"
else
  echo "❌ SSH connection failed"
  echo "Possible issues:"
  echo "  - SSH key not authorized on remote host"
  echo "  - SSH server not running on remote host"
  echo "  - Firewall blocking connection"
  echo "  - Network connectivity issues"
  exit 1
fi

# Test Nix availability on remote
echo "Testing Nix on remote host..."
if ssh -i "$SSH_KEY" "${SSH_USER}@${REMOTE_IP}" "which nix-store && nix-store --version"; then
  echo "✅ Nix is available on remote host"
else
  echo "❌ Nix not found on remote host"
  exit 1
fi

# Test if user is trusted
echo "Testing if user is a trusted Nix user..."
if ssh -i "$SSH_KEY" "${SSH_USER}@${REMOTE_IP}" "grep -q \"${SSH_USER}\" /etc/nix/nix.conf && echo Found in nix.conf || echo Not found in nix.conf"; then
  echo "✅ User appears to be configured correctly"
else
  echo "⚠️ User might not be in trusted-users on remote host"
  echo "Recommended: Add '${SSH_USER}' to trusted-users in the remote host's configuration"
fi

# Test a simple remote build
echo "Testing a simple remote build..."
echo "nix-build --expr 'with import <nixpkgs> {}; runCommand \"test\" {} \"echo success > \$out\"' --option builders \"ssh://${SSH_USER}@${REMOTE_IP}\"" | bash

if [[ $? -eq 0 ]]; then
  echo "✅ Remote build successful"
else
  echo "❌ Remote build failed"
  echo "Check the error message above for details"
fi

echo
echo "Remote builder test complete."