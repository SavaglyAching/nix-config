{
  description = "NixOS Configuration";

  inputs = {
    # You can keep this on unstable if you wish
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # --- ADDED: sops-nix input ---
    sops-nix.url = "github:Mic92/sops-nix";

    # --- ADDED: unstable input for the latest sops tool ---
    # Your configuration.nix refers to `unstable.sops`, so this is required.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # --- ADDED: home-manager input ---
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # --- UPDATED: Add sops-nix and nixpkgs-unstable to function arguments ---
  outputs = { self, nixpkgs, nixos-hardware, sops-nix, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # --- Your Other Host Configurations ---

      "nixos-desk" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # --- ADDED: specialArgs to pass unstable packages to your config ---
        specialArgs = {
          unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
        };
        # --- UPDATED: Added the sops-nix module ---
        modules = [
          ./hosts/nixos-desk
          sops-nix.nixosModules.sops # This line enables the `sops` option
          home-manager.nixosModules.home-manager
        ];
      };

      "nixos-rica" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-rica
        sops-nix.nixosModules.sops # This line enables the `sops` option
        home-manager.nixosModules.home-manager
      home-manager.nixosModules.home-manager
      ];
    };

      "nixos-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # --- ADDED: specialArgs to pass unstable packages to your config ---
        specialArgs = {
          unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
        };
        # --- UPDATED: Added the sops-nix module ---
        modules = [
          ./hosts/nixos-mini
          sops-nix.nixosModules.sops # This line enables the `sops` option
          home-manager.nixosModules.home-manager
        ];
      };

      "nixos-mini-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-mini-vm
          home-manager.nixosModules.home-manager
        ];
      };

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm
          home-manager.nixosModules.home-manager
        ];
      };

      "surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # If you need packages from nixpkgs-unstable in your surface configuration,
          # pass them explicitly, just like in your other hosts.
          unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
        };
        modules = [
          # Your machine-specific configurations come first
          ./hosts/surface

          # Then, add modules for additional functionality like sops
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          # Finally, the hardware module. This is critical for Wi-Fi.
          # It provides the necessary kernel, modules, and firmware.
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ];
      };
    };
  };
}