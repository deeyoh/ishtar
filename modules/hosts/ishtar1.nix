{ inputs, config, ... }: let
  system = "x86_64-linux";
in
{
  flake.modules.nixos.ishtar1 = { pkgs, ... }: {
    imports = [
      # shared infra
      config.flake.modules.nixos.home-manager
      config.flake.modules.nixos.gen-base
      config.flake.modules.nixos.quadlet
      config.flake.modules.nixos.podman-rootless
      config.flake.modules.nixos.nixos-base

      # services
      config.flake.modules.nixos.actual-budget
      config.flake.modules.nixos.fast-note-sync
      config.flake.modules.nixos.homeassistant
      config.flake.modules.nixos.minecraft-server
      config.flake.modules.nixos.tailscale
      config.flake.modules.nixos.tailscale-serve
      config.flake.modules.nixos.vault-warden
      config.flake.modules.nixos.forgejo
      config.flake.modules.nixos.searxng
      config.flake.modules.nixos.rex-server

      # machine-specific config
      ../../machines/ishtar1/configuration.nix
    ];

    programs.zsh.enable = true;
    nix.settings.experimental-features = "nix-command flakes";

    nixpkgs.hostPlatform = system;

    home-manager = {
      backupFileExtension = "hm-backup";
      useGlobalPkgs = true;
      users.dio = {
        imports = [
          # config.flake.modules.homeManager.chrome
          config.flake.modules.homeManager.zsh
        ];
      };
    };
  };

  flake.nixosConfigurations.ishtar1 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      vars = import ../../vars.nix;
    };

    modules = [
      config.flake.modules.nixos.ishtar1
    ];
  };
}
