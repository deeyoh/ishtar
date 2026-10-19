{ inputs, config, ... }:
{
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };

      specialArgs = {
        inherit inputs;
        vars = import ../vars.nix;
      };
    };

    ishtar1 = {
      imports = [
        config.flake.nixosModules.ishtar1
      ];

      deployment = {
        targetHost = "192.168.1.51";
        targetUser = "root";
      };
    };

    ishtar-edge = {
      imports = [
        config.flake.nixosModules.ishtar-edge
      ];

      deployment = {
        targetHost = "100.75.15.36";
        targetUser = "root";
      };
    };
  };
}
