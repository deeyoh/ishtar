{
  flake.nixosModules.tailscale-non-headless = { config, ... }: {
    # module for non-headless machines, for headless, refer to `services/tailscale`
    services.tailscale.enable = true;
  };

  flake.darwinModules.tailscale = {
    services.tailscale.enable = true;
  };
}
