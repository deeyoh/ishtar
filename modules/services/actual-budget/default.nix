{ config, ... }: {
  flake.nixosModules.actual-budget = {
    imports = [
      ./service.pkg.nix
    ];
  };
}
