{ inputs, config, ... }: let
  system = "aarch64-darwin";
in
{
  flake.darwinModules.gamma = { pkgs, ... }: {
    imports = [
      (config.flake.homeManager system)
      config.flake.darwinModules.homebrew
      config.flake.darwinModules.bitwarden
      config.flake.darwinModules.discord
      config.flake.darwinModules.tailscale-non-headless
    ];

    system.primaryUser = "dio";
    system.stateVersion = 6;
    programs.zsh.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.hostPlatform = system;
    users.users.dio.home = "/Users/dio";

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = { inherit inputs; };
      users.dio = {
        home.stateVersion = "26.05";
        imports = [
          config.flake.homeModules.neovim
          config.flake.homeModules.bitwarden-ssh
          config.flake.homeModules.aerospace
          config.flake.homeModules.chrome
          config.flake.homeModules.direnv
          config.flake.homeModules.ghostty
          config.flake.homeModules.jujutsu
          config.flake.homeModules.pi
          config.flake.homeModules.tmux
          config.flake.homeModules.zsh
        ];
      };
    };
  };

  flake.darwinConfigurations.gamma = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };

    modules = [
      config.flake.darwinModules.gamma
    ];
  };
}
