# Remote Builder Setup

This document explains how to set up and troubleshoot the remote builder configuration in this NixOS system.

## Overview

The remote builder allows you to offload Nix builds to a more powerful machine on your network. This is particularly useful for devices like the Surface Pro, which may have limited resources or thermal constraints.

## Configuration

The remote builder setup consists of two parts:

1. **Client Configuration** (the machine that wants to use a remote builder)
2. **Builder Configuration** (the machine that will perform the builds)

### Client Configuration

To configure a machine to use a remote builder:

```nix
# In your host configuration (e.g., hosts/nixos-surface/default.nix)
services.remote-builder = {
  enable = true;
  isBuilder = false;
  builderUser = "ham";  # The user on the remote machine
  sshKeyPath = "/home/ham/.ssh/id_ed25519";  # Path to your SSH key
  builderIP = "192.168.2.254";  # IP or hostname of the remote builder
  maxJobs = 8;  # Maximum concurrent jobs
};
```

### Builder Configuration

To configure a machine to act as a remote builder:

```nix
# In your host configuration (e.g., hosts/nixos-desk/default.nix)
services.remote-builder = {
  enable = true;
  isBuilder = true;
  builderUser = "ham";  # The user that will perform the builds
};

# Ensure the builder user is trusted
nix.settings.trusted-users = [ "ham" ];
```

## SSH Key Setup

For the remote builder to work, SSH key authentication must be properly set up:

1. Ensure the SSH key exists at the specified path on the client machine
2. Make sure the public key is in the `authorized_keys` file for the builder user on the remote machine

### Surface Pro 7 Specific Setup

The Surface Pro 7 uses a dedicated SSH key for remote building:

```
# Key path on Surface
/home/ham/.ssh/surface-remote-builder

# Public key (already added to ham user's authorized_keys)
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5ryKKKc1NZBKj/wXIQynMvcIGQ0knE/hXfc+d4UCMn surface-remote-builder
```

If you need to generate a new key:

```bash
# On the client machine (e.g., nixos-surface)
ssh-keygen -t ed25519 -f ~/.ssh/surface-remote-builder -C "surface-remote-builder"

# Copy the key to the remote builder
ssh-copy-id -i ~/.ssh/surface-remote-builder.pub ham@192.168.2.254
```

## Testing the Connection

To test if the SSH connection works properly:

```bash
# On the client machine
ssh -i /home/ham/.ssh/id_ed25519 ham@192.168.2.254

# If this works, try a simple Nix command
ssh -i /home/ham/.ssh/id_ed25519 ham@192.168.2.254 "nix-store --version"
```

## Troubleshooting

### Connection Closed by Remote Host

If you see "Connection to X.X.X.X closed by remote host", check:

1. SSH key permissions (should be 600 for private key)
2. Authorized keys on the remote machine
3. SSH server configuration on the remote machine
4. Firewall settings on both machines

### SSH Key Permissions

```bash
# Fix permissions on the SSH key
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### Checking SSH Logs

On the remote builder, check the SSH logs for clues:

```bash
sudo journalctl -u sshd -f
```

### Firewall Issues

Make sure the firewall allows SSH connections:

```bash
# On the remote builder
sudo iptables -L | grep 22
```

## Advanced Configuration

For more advanced configurations, you can modify the `remote-builder.nix` module directly.