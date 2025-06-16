# flake.nix
{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware"; # No need to specify /master, Flakes will find the default branch.

    # CORRECTED URL: It's 'linux-surface', not 'nixos-surface'.
    nix-surface.url = "github:linux-surface/nix-surface";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-surface, ... }@inputs: {
    nixosConfigurations = {
      "nixos-desk" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-desk ];
      };

      "nixos-rica" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-rica ];
      };

      "nixos-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-mini ];
      };

      "nixos-mini-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-mini-vm ];
      };

      "nixos-surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # This is no longer needed as we pass the whole inputs set
          # inherit nix-surface;
          inherit inputs;
        };
        modules = [
          # Import the main configuration file for the Surface Pro
          ./hosts/nixos-surface

          # Apply the Surface Pro 7 specific hardware settings from nixos-hardware
          nixos-hardware.nixosModules.microsoft-surface-pro-7

          # Apply the linux-surface kernel module
          # CORRECTED: The module path is nix-surface.nixosModules.default
          nix-surface.nixosModules.default
        ];
      };

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-vm ];
      };
    };
  };
}