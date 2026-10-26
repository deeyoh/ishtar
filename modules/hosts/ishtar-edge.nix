{ inputs, config, ... }: let
  system = "aarch64-linux";
in
{
  flake.modules.nixos.ishtar-edge = {
    imports = [
      config.flake.modules.nixos.gen-base

      config.flake.modules.nixos.tailscale

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
      config.flake.modules.nixos.ishtar-edge
    ];
  };
}
