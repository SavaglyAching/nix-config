{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Corrected URL: Explicitly points to the 'main' branch to resolve fetch errors.
    # This flake provides the linux-surface kernel.
    nix-surface.url = "github:linux-surface/nix-surface/main";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-surface, ... }@inputs: {
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

      # --- Surface Pro 7 Configuration ---
      "nixos-surface" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # Pass all flake inputs to the modules
          inherit inputs;
        };
        modules = [
          # 1. Import your host-specific configuration
          ./hosts/nixos-surface

          # 2. Apply the specific hardware profile for the Surface Pro 7
          nixos-hardware.nixosModules.microsoft-surface-pro-7

          # 3. Apply the nix-surface module, which provides the patched kernel
          nix-surface.nixosModules.default
        ];
      };
    };
  };
}