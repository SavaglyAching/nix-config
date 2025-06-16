{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-surface.url = "github:nixos-surface/nix-surface";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-surface, ... }@inputs: {
    nixosConfigurations = {
      "nixos-desk" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-desk
        ];
      };

      "nixos-rica" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-rica
        ];
      };

      "nixos-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-mini
        ];
      };

      "nixos-mini-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-mini-vm
        ];
      };

      "nixos-surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # Pass nix-surface to the configuration
          inherit nix-surface;
        };
        modules = [
          # Import the main configuration file for the Surface Pro
          ./hosts/nixos-surface

          # Apply the Surface Pro 7 specific hardware settings
          nixos-hardware.nixosModules.microsoft-surface-pro-7

          # You can add other global modules here if needed
          nix-surface.nixosModules.surface
        ];
      };

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm
        ];
      };
    };
  };
}
