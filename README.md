# NixOS Configuration

This repository contains my NixOS configuration using the Nix Flakes system. It's organized to support multiple machines with shared modules.

## Repository Structure

```
.
├── flake.nix
├── flake.lock
├── README.md
├── secrets.yaml
├── todo
├── dotfiles/
│   ├── README.md
│   ├── ssh/
│   └── zsh/
├── home/
│   ├── zsh.nix
│   └── users/
│       └── ham.nix
├── hosts/
│   ├── asahi/           # Apple Silicon Mac (M1/M2/M3)
│   │   ├── default.nix
│   │   ├── disko.nix
│   │   ├── firmware/
│   │   └── hardware-configuration.nix
│   ├── nixos-desk/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── nixos-mini/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── nixos-rica/
│   │   ├── boot.nix
│   │   ├── caddy.nix
│   │   ├── default.nix
│   │   ├── docker.nix
│   │   ├── hardware-configuration.nix
│   │   ├── network.nix
│   │   └── samba.nix
│   ├── nixos-surface/
│   │   └── hardware-configuration.nix
│   ├── surface/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── template/
│       └── default.nix
├── modules/
│   ├── desktop/
│   │   ├── gnome.nix
│   │   ├── kde.nix
│   │   └── xfce.nix
│   ├── gaming/
│   │   └── gaming.nix
│   ├── services/
│   │   ├── docker.nix
│   │   ├── ollama.nix
│   │   ├── pmc-25.nix
│   │   ├── remote-desktop.nix
│   │   ├── samba.nix
│   │   ├── ssh.nix
│   │   └── tailscale.nix
│   └── system/
│       ├── boot.nix
│       ├── btrfs.nix
│       ├── desktop.nix
│       ├── network.nix
│       ├── nix.nix
│       ├── packages.nix
│       ├── remote-builder.nix
│       ├── sops-smb.nix
│       └── users.nix
```

## Usage

### Rebuilding the System

To rebuild the system using this configuration:

```bash
# From the repository directory
sudo nixos-rebuild switch --flake .#nixos-desk

# For Apple Silicon Mac
sudo nixos-rebuild switch --flake .#asahi

# For Surface
sudo nixos-rebuild switch --flake .#surface
```

**Note**: This configuration supports multiple architectures:
- **x86_64-linux**: desk, rica, mini, surface
- **aarch64-linux**: asahi (Apple Silicon Macs - M1/M2/M3)

The Asahi configuration requires the [Asahi Linux UEFI environment](https://asahilinux.org/) to be installed first from macOS. See [docs/asahi-installation.md](docs/asahi-installation.md) for complete installation instructions.

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


  environment.systemPackages = [
    pkgs.aider-chat-with-playwright
  ];

  # Correct sops configuration
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets.openrouter_api_key = {
      # This makes the secret available at /run/secrets/openrouter_api_key
      # and creates a NixOS option config.sops.secrets.openrouter_api_key.path
      # to refer to its runtime path.
    };
  };


  # :)# nix-config
