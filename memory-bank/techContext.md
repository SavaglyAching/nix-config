# NixOS Configuration Technical Context

## Technologies Used

### Core Technologies

1. **NixOS**
   - Version: Based on nixos-unstable channel
   - A Linux distribution built on the Nix package manager
   - Declarative system configuration
   - Atomic upgrades and rollbacks

2. **Nix Flakes**
   - Provides reproducible builds and deployments
   - Locks dependencies to specific versions
   - Enables modular configuration composition
   - Experimental feature enabled in configuration

3. **Home Manager**
   - Manages user environments
   - Integrated with NixOS via the nixosModules.home-manager module
   - Configured to use global packages and user packages

### Key Services

1. **Desktop Environment**
   - KDE Plasma 6
   - SDDM display manager

2. **System Services**
   - SSH server (OpenSSH)
   - Tailscale VPN
   - Ollama AI (with ROCm acceleration)
   - Docker virtualization
   - BTRFS maintenance (auto-scrub)

3. **Shell Environment**
   - ZSH as default shell
   - TMUX for terminal multiplexing
   - Mosh for mobile shell access

## Development Setup

### Repository Structure

The repository follows a modular structure:
- `flake.nix`: Entry point for the configuration
- `hosts/`: Machine-specific configurations
- `modules/`: Shared configuration modules
- `home/`: Home Manager user configurations

### Build and Deployment

To build and deploy the configuration:
```bash
# From the repository directory
sudo nixos-rebuild switch --flake .#hostname
```

Where `hostname` is the name of the host configuration to build.

## Technical Constraints

1. **Hardware Compatibility**
   - Current configuration supports AMD-based systems
   - LUKS encryption for disk security
   - EFI boot system

2. **Network Configuration**
   - Configured for Ethernet with DHCP
   - Firewall enabled with specific ports open
   - Tailscale for secure remote access

3. **Security Considerations**
   - SSH password authentication disabled
   - Root login via SSH disabled
   - Firewall configured to block most incoming connections
   - LUKS encryption for system drive

## Dependencies

### System Dependencies

Core system packages include:
- System tools: btop, htop, ncdu, mc, micro, tmux, mosh
- System administration: btrfs-progs, nmap, iotop, dnsutils
- File utilities: curl, wget, fzf, ripgrep, fd, tree
- Development tools: git, gitui, lazygit, lazydocker, python3
- Media tools: ffmpeg-full, gallery-dl, instaloader, spotdl, yt-dlp
- Desktop applications: vscode-fhs, firefox, librewolf

### External Dependencies

- GitHub repositories:
  - nixpkgs: github:nixos/nixpkgs/nixos-unstable
  - home-manager: github:nix-community/home-manager