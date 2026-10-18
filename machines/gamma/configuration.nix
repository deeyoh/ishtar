{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.darwinModules.default
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
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
      imports = [
        ../../modules/home/nixcats/nixcats-config.nix
        ../../modules/home/terminal/ghostty.nix
        ../../modules/home/general/chrome.nix
      ];
      programs.zsh = {
        enable = true;
	enableCompletion = true;
	autosuggestion.enable = true;
	syntaxHighlighting.enable = true;
	shellAliases = {
          rebuild = "sudo darwin-rebuild switch --flake ~/ishtar#gamma";
	};
	history = {
	  size = 10000;
	  save = 10000;
	  ignoreDups = true;
	};
      };
      home.stateVersion = "26.05";
    };
  };
}
