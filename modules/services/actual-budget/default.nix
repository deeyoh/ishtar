{ config, ... }: {
  flake.modules.nixos.actual-budget = {
    imports = [
      config.flake.modules.nixos.utils
      ./service.pkg.nix
    ];
  };
}
