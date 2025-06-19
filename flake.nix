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
  };

  # --- UPDATED: Add sops-nix and nixpkgs-unstable to function arguments ---
  outputs = { self, nixpkgs, nixos-hardware, sops-nix, nixpkgs-unstable, ... }@inputs: {
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
        ];
      };

      "nixos-rica" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-rica
        sops-nix.nixosModules.sops # This line enables the `sops` option
         ];
      };

      "nixos-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-mini
        sops-nix.nixosModules.sops # This line enables the `sops` option
         ];
      };

      "nixos-mini-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-mini-vm ];
      };

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-vm ];
      };

      "nixos-surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/nixos-surface
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ];
      };
    };
  };
}