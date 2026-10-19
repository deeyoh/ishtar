{ inputs, config, ... }: let
  system = "x86_64-linux";
in
{
  flake.nixosModules.ishtar1 = {
    imports = [
      # shared infra
      (config.flake.homeManager system)
      config.flake.nixosModules.gen-base
      config.flake.nixosModules.quadlet
      config.flake.nixosModules.podman-rootless
      config.flake.nixosModules.nixos-base

      # services
      config.flake.nixosModules.actual-budget
      config.flake.nixosModules.fast-note-sync
      config.flake.nixosModules.homeassistant
      config.flake.nixosModules.minecraft-server
      config.flake.nixosModules.tailscale
      config.flake.nixosModules.tailscale-serve
      config.flake.nixosModules.vault-warden

      # machine-specific config
      ../../machines/ishtar1/configuration.nix
    ];

    nixpkgs.hostPlatform = system;
  };

  flake.nixosConfigurations.ishtar1 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      vars = import ../../vars.nix;
    };

    modules = [
      config.flake.nixosModules.ishtar1
    ];
  };
}
