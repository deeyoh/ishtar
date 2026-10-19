{ config, ... }: {
  flake.modules.nixos.homeassistant = {
    imports = [
      config.flake.modules.nixos.utils
      ./service.pkg.nix
    ];
  };
}
