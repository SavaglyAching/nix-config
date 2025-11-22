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
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, nixos-apple-silicon, sops-nix, disko, home-manager, nix-fast-build, nix-on-droid, ... }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = {
        unstable = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        stable = import nixpkgs-stable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
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

      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          specialArgs = specialArgs;
        };

        defaults = {
          deployment.targetUser = "ham";
        };

        desk = {
          deployment.targetHost = "desk";
          imports = [ ./hosts/desk ] ++ commonModules;
        };

        rica = {
          deployment.targetHost = "rica";
          imports = [ ./hosts/rica ] ++ commonModules;
        };

        mini = {
          deployment.targetHost = "mini";
          imports = [ ./hosts/mini ] ++ commonModules;
        };

        surface = {
          deployment.targetHost = "surface";
          imports = [ ./hosts/surface nixos-hardware.nixosModules.microsoft-surface-pro-intel ] ++ commonModules;
        };
      };

      # ISO image outputs
      packages.${system} = {
        surface-iso = nixosConfigs.surface-installer.config.system.build.isoImage;
        # System builds
        desk = nixosConfigs.desk.config.system.build.toplevel;
        rica = nixosConfigs.rica.config.system.build.toplevel;
        mini = nixosConfigs.mini.config.system.build.toplevel;
        surface = nixosConfigs.surface.config.system.build.toplevel;
      };

      packages."aarch64-linux" = {
        asahi-iso = nixosConfigs.asahi-installer.config.system.build.isoImage;
        # System build
        asahi = nixosConfigs.asahi.config.system.build.toplevel;
      };

      # Checks for nix-fast-build
      checks.x86_64-linux = {
        desk = nixosConfigs.desk.config.system.build.toplevel;
        rica = nixosConfigs.rica.config.system.build.toplevel;
        mini = nixosConfigs.mini.config.system.build.toplevel;
        surface = nixosConfigs.surface.config.system.build.toplevel;
        surface-iso = nixosConfigs.surface-installer.config.system.build.isoImage;
      };

      checks."aarch64-linux" = {
        asahi = nixosConfigs.asahi.config.system.build.toplevel;
        asahi-iso = nixosConfigs.asahi-installer.config.system.build.isoImage;
      };

      # Nix-on-Droid configuration
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        modules = [ ./hosts/nix-on-droid ];
      };
    };
}
