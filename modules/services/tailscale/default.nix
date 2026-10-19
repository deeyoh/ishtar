{ config, ... }: {
  flake.nixosModules.tailscale-serve = {
    imports = [
      config.flake.nixosModules.utils
      ./tailscale-serve.pkg.nix
    ];
  };

  flake.nixosModules.tailscale = {
    imports = [
      ./tailscale.pkg.nix
    ];
  };
}
