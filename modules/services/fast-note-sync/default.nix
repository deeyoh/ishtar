{ config, ... }: {
  flake.nixosModules.fast-note-sync = {
    imports = [
      config.flake.nixosModules.utils
      ./service.pkg.nix
    ];
  };
}
