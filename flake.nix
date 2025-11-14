{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-apple-silicon.url = "github:nix-community/nixos-apple-silicon";
    sops-nix.url = "github:Mic92/sops-nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, nixos-apple-silicon, sops-nix, disko, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = {
        unstable = import nixpkgs { inherit system; config.allowUnfree = true; };
        stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
      };
      commonModules = [
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        ./system/home-manager.nix
        ({ config, ... }: {
          nix.settings.substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://nixos-apple-silicon.cachix.org"
          ];
        })
      ];
      nixosConfigs = {
        "desk" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/desk ] ++ commonModules;
        };

        "rica" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/rica ] ++ commonModules;
        };

        "mini" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/mini ] ++ commonModules;
        };

        "surface" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/surface
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ] ++ commonModules;
        };

        # Surface installer ISO
        "surface-installer" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./installer/surface-iso.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ] ++ commonModules;
        };

        # Asahi host (Apple Silicon)
        "asahi" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            unstable = import nixpkgs {
              system = "aarch64-linux";
              config.allowUnfree = true;
              overlays = [ nixos-apple-silicon.overlays.apple-silicon-overlay ];
            };
            stable = import nixpkgs-stable {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/asahi
            nixos-apple-silicon.nixosModules.apple-silicon-support
          ] ++ commonModules;
        };

        # Asahi installer ISO
        "asahi-installer" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            unstable = import nixpkgs {
              system = "aarch64-linux";
              config.allowUnfree = true;
              overlays = [ nixos-apple-silicon.overlays.apple-silicon-overlay ];
            };
            stable = import nixpkgs-stable {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./installer/asahi-iso.nix
            nixos-apple-silicon.nixosModules.apple-silicon-support
          ] ++ commonModules;
        };
      };
    in
    {
      nixosConfigurations = nixosConfigs;

      # ISO image outputs
      packages.${system} = {
        surface-iso = nixosConfigs.surface-installer.config.system.build.isoImage;
      };

      packages."aarch64-linux" = {
        asahi-iso = nixosConfigs.asahi-installer.config.system.build.isoImage;
      };
    };
}
