{ inputs, config, ... }: let
  system = "aarch64-linux";
in
{
  flake.nixosModules.ishtar-edge = {
    imports = [
      config.flake.nixosModules.gen-base
      ../../machines/ishtar-edge/configuration.nix
    ];

    nixpkgs.hostPlatform = system;
  };

  flake.nixosConfigurations.ishtar-edge = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      vars = import ../../vars.nix;
    };

    modules = [
      config.flake.nixosModules.ishtar-edge
    ];
  };
}
