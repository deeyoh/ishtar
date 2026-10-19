{ config, ... }: {
  flake.nixosModules.homeassistant = {
    imports = [
      config.flake.nixosModules.utils
      ./service.pkg.nix
    ];
  };
}
