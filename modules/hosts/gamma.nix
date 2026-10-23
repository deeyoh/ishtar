{ inputs, config, ... }: let
  system = "aarch64-darwin";
in
{
  flake.modules.darwin.gamma = { pkgs, ... }: {
    imports = [
      config.flake.modules.darwin.home-manager
      config.flake.modules.darwin.homebrew
      config.flake.modules.darwin.bitwarden
      config.flake.modules.darwin.discord
      config.flake.modules.darwin.tailscale
      config.flake.modules.darwin.dinky
    ];

    system.primaryUser = "dio";
    system.stateVersion = 6;
    programs.zsh.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = "nix-command flakes";
    nix.linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
    };
    nix.settings.trusted-users = [ "root" "dio" ];
    nixpkgs.hostPlatform = system;
    users.users.dio.home = "/Users/dio";

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = { inherit inputs; };
      users.dio = {
        home.stateVersion = "26.05";
        imports = [
          config.flake.modules.homeManager.neovim
          config.flake.modules.homeManager.bitwarden-ssh
          config.flake.modules.homeManager.chrome
          config.flake.modules.homeManager.direnv
          config.flake.modules.homeManager.ghostty
          config.flake.modules.homeManager.jujutsu
          config.flake.modules.homeManager.pi
          config.flake.modules.homeManager.zsh
        ];
      };
    };
  };

  flake.darwinConfigurations.gamma = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };

    modules = [
      config.flake.modules.darwin.gamma
    ];
  };
}
