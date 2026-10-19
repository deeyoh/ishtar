{ config, ... }: {
  flake.modules.nixos.fast-note-sync = {
    imports = [
      config.flake.modules.nixos.utils
      ./service.pkg.nix
    ];
  };
}
