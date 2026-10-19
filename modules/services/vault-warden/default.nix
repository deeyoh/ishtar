{ config, ... }: {
  flake.nixosModules.vault-warden = {
    imports = [
      config.flake.nixosModules.utils
      ./service.pkg.nix
    ];
  };
}
