{
  description = "Ishtar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

   nix-homebrew = {
     url = "github:zhaofengli/nix-homebrew";
     inputs.nixpkgs.follows = "nixpkgs-darwin";
   };

   homebrew-core = {
     url = "github:homebrew/homebrew-core";
     flake = false;
   };

   homebrew-cask = {
     url = "github:homebrew/homebrew-cask";
     flake = false;
   };

   nixCats = {
     url = "github:BirdeeHub/nixCats-nvim";
     inputs.nixpkgs.follows = "nixpkgs";
   };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      colmena,
      disko,
      sops-nix,
      quadlet-nix,
      home-manager,
      ...
    }:
    let
      workstation_system = "x8_64-linux";
      platforms = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllPlatforms = f:
        nixpkgs.lib.genAttrs platforms (system: f (mkPkgs system));

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "terraform"
          ];
      };

      
      vars = import ./vars.nix;

      mkNixOSConfig =
        {
          hostConfig,
          hostPlatform ? "x86_64-linux",
          extraModules ? [ ],
          extraOverlays ? [ ]
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs vars; };

          modules = [
            {
              nixpkgs.hostPlatform = hostPlatform;
              nixpkgs.overlays = extraOverlays;
            }
            hostConfig
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
          ]
          ++ extraModules;
        };

        tests = import ./tests { inherit pkgs inputs; };

      ishtar1path = ./machines/ishtar1/configuration.nix;
      pkgs = mkPkgs workstation_system;
    in
    {
      devShells = forAllPlatforms (pkgs: {
        default = import ./shell.nix { 
          inherit pkgs;
          colmena = colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena;
        };
      });

      checks.${workstation_system} = tests;

      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = pkgs;
          specialArgs = { inherit inputs vars; };
        };

        ishtar1 = {
          nixpkgs.hostPlatform = "x86_64-linux";
          imports = [
            ishtar1path
            disko.nixosModules.disko
            quadlet-nix.nixosModules.quadlet
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
          ];

          deployment = {
            targetHost = "192.168.1.51";
            targetUser = "root";
          };
        };

        ishtar-edge = {
          nixpkgs.hostPlatform = "aarch64-linux";
          imports = [
            ./machines/ishtar-edge/configuration.nix
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];

          deployment = {
            targetHost = "100.75.15.36";
            targetUser = "root";
          };
        };
      };

      nixosConfigurations = {
        ishtar1 = mkNixOSConfig {
          hostConfig = ./machines/ishtar1/configuration.nix;
          hostPlatform = "x86_64-linux";

          extraModules = [
            quadlet-nix.nixosModules.quadlet
            home-manager.nixosModules.home-manager
          ];
        };

        ishtar-edge = mkNixOSConfig {
          hostConfig = ./machines/ishtar-edge/configuration.nix;
          hostPlatform = "aarch64-linux";
        };

        iso1ishtar = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs vars; };
          modules = [
            ./iso/config.nix
          ];
        };
      };

      darwinConfigurations.gamma = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/gamma/configuration.nix
        ];
      };

      packages.aarch64-linux.oracle-vps-image =
        self.nixosConfigurations.ishtar-edge.config.system.build.OCIImage;

      packages.${workstation_system}.tests = pkgs.runCommand "tests" {
        buildInputs = builtins.attrValues tests;
      } ''
        mkdir -p $out
      '';
    };
}
