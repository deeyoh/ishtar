{ config, ... }: {
  flake.modules.nixos.tailscale-serve = {
    imports = [
      config.flake.modules.nixos.utils
      ./tailscale-serve.pkg.nix
    ];
  };

  flake.modules.nixos.tailscale = {
    imports = [
      ./tailscale.pkg.nix
    ];
  };
}
