{ config, ... }: {
  flake.modules.nixos.vault-warden = {
    imports = [
      config.flake.modules.nixos.utils
      ./service.pkg.nix
    ];
  };
}
