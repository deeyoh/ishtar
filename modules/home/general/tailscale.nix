{ inputs, ... }: {
  flake.modules.nixos.tailscale-non-headless = { config, ... }: {
    # module for non-headless machines, for headless, refer to `services/tailscale`
    services.tailscale.enable = true;
  };

  flake.modules.darwin.tailscale = { pkgs, ... }: {
    services.tailscale = {
      enable = true;
      package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
    };
  };
}
