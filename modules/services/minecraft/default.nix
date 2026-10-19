{ config, ... }: {
  flake.nixosModules.minecraft-server = {
    imports = [
      config.flake.nixosModules.utils
      ./service.pkg.nix
    ];
  };
}
