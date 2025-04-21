{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Add sops-nix input
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Add Zen Browser flake
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, sops-nix, zen-browser, ... }@inputs: {
    nixosConfigurations = {
      "nixos-desk" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-desk
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops  # Add sops module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ham = import ./home/ham.nix {
              inherit zen-browser;
            };
          }
        ];
      };
      
      "nixos-rica" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-rica
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops  # Add sops module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ham = import ./home/ham.nix;
          }
        ];
      };

      "nixos-mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-mini
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
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops  # Add sops module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ham = import ./home/ham.nix;
          }
        ];
      };

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops  # Add sops module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ham = import ./home/ham.nix;
          }
        ];
      };
    };
  };
}
  };
}
