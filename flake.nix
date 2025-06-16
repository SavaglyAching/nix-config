{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # This is the only hardware-specific input you need.
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  # Note: 'nix-surface' is removed from the function arguments here.
  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      # --- Your Other Host Configurations ---
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

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/nixos-vm ];
      };

      # --- Surface Pro 7 Configuration (Corrected) ---
      "nixos-surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          # 1. Your host-specific configuration file.
          ./hosts/nixos-surface

          # 2. The module for the Surface Pro 7 from nixos-hardware.
          # This single line handles the kernel, firmware, and other settings.
          nixos-hardware.nixosModules.microsoft-surface-pro-7
        ];
      };
    };
  };
}