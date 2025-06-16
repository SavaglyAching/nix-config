{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Corrected URL: Explicitly points to the 'main' branch to resolve fetch errors.
    nix-surface.url = "github:linux-surface/nix-surface/main";
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
          inherit inputs;
        };
        modules = [
          # Import the main configuration file for the Surface Pro
          ./hosts/nixos-surface

          # Apply the Surface Pro 7 specific hardware settings from nixos-hardware
          nixos-hardware.nixosModules.microsoft-surface-pro-7

          # Apply the linux-surface kernel module
          nix-surface.nixosModules.default
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