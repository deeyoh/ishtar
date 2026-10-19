{ config, ... }: {
  flake.modules.nixos.minecraft-server = {
    imports = [
      config.flake.modules.nixos.utils
      ./service.pkg.nix
    ];
  };
}
