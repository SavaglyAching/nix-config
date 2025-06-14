{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
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
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops  # Add sops module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ham = import ./home/ham.nix;
          }
        ];
      };

      "nixos-surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-surface
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
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
