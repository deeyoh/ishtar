{ inputs, ... }: {
  flake.modules.darwin.dinky = {
    nix-homebrew.taps."mikker/homebrew-tap" = inputs.homebrew-mikker;
    homebrew.casks = [ "mikker/tap/dinky" ];
  };
}
