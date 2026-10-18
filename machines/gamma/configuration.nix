{ pkgs, ... }: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 6;

  environment.systemPackages = with pkgs; [
    neovim
  ];
}
