{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.darwinModules.default
    ../../modules/home/general/homebrew.nix
    ../../modules/home/general/discord.nix
    ../../modules/home/general/aerospace.nix
    ../../modules/home/general/bitwarden.nix
    ../../modules/home/general/tailscale.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.primaryUser = "dio";
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [
    neovim
    jujutsu
  ];

  users.users.dio.home = "/Users/dio";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs; };
    users.dio = {
      home.stateVersion = "26.05";
      imports = [
        ../../modules/home/nixcats/nixcats-config.nix
        ../../modules/home/terminal/ghostty.nix
        ../../modules/home/general/chrome.nix
        ../../modules/home/terminal/tmux.nix
        ../../modules/home/terminal/zsh.nix
        ../../modules/home/terminal/direnv.nix
      ];
    };
  };
}
