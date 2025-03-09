# NixOS Configuration

This repository contains my NixOS configuration using the Nix Flakes system. It's organized to support multiple machines with shared modules.

## Repository Structure

```
.
├── flake.nix              # Main flake configuration
├── flake.lock             # Flake lock file
├── hosts/                 # Host-specific configurations
│   ├── nixos-desk/        # Configuration for nixos-desk machine
│   │   ├── default.nix    # Main configuration for this host
│   │   └── hardware-configuration.nix  # Hardware-specific configuration
│   └── template/          # Template for new hosts
├── modules/               # Shared configuration modules
│   ├── desktop/           # Desktop environment modules
│   │   └── kde.nix        # KDE Plasma configuration
│   ├── services/          # Service modules
│   │   ├── docker.nix     # Docker configuration
│   │   ├── ollama.nix     # Ollama AI service
│   │   ├── ssh.nix        # SSH server configuration
│   │   └── tailscale.nix  # Tailscale VPN configuration
│   └── system/            # System modules
│       ├── boot.nix       # Boot configuration
│       ├── btrfs.nix      # BTRFS maintenance
│       ├── network.nix    # Network configuration
│       ├── nix.nix        # Nix-specific settings
│       ├── packages.nix   # System packages
│       ├── shell.nix      # Shell configuration
│       └── users.nix      # User accounts
└── home/                  # Home-manager configurations
    ├── ham.nix            # Configuration for user 'ham'
    └── template.nix       # Template for new users
```

## Usage

### Rebuilding the System

To rebuild the system using this configuration:

```bash
# From the repository directory
sudo nixos-rebuild switch --flake .#nixos-desk
```

### Adding a New Host

To add a new host:

1. Copy the template directory: `cp -r hosts/template hosts/your-hostname`
2. Generate hardware configuration using `nixos-generate-config` and copy the hardware-configuration.nix to the new host directory
3. Edit the `default.nix` file in the host directory, uncommenting necessary modules
4. Add the new host to `flake.nix` under `nixosConfigurations`

Example for adding a new laptop host:

```bash
# Copy the template
cp -r hosts/template hosts/nixos-laptop

# Generate hardware configuration (after booting into NixOS installer)
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hosts/nixos-laptop/

# Edit default.nix to customize for the laptop
nano hosts/nixos-laptop/default.nix

# Add to flake.nix under nixosConfigurations
nano flake.nix
```

Add the following to flake.nix:

```nix
"nixos-laptop" = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/nixos-laptop
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.username = import ./home/username.nix;
    }
  ];
};
```

### Adding a New User

To add a new user:

1. Copy the template file: `cp home/template.nix home/username.nix`
2. Edit the file to customize for the user
3. Add the user to the appropriate host configuration in flake.nix

## Customization

### Adding New Modules

To add a new module:

1. Create a new `.nix` file in the appropriate subdirectory under `modules/`
2. Import the module in the host configuration where needed

### Modifying Home Manager Configuration

To customize the home manager configuration:

1. Edit the appropriate file under `home/`
2. Rebuild the system to apply changes