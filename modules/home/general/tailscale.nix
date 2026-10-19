{
  flake.modules.nixos.tailscale-non-headless = { config, ... }: {
    # module for non-headless machines, for headless, refer to `services/tailscale`
    services.tailscale.enable = true;
  };

  flake.modules.darwin.tailscale = {
    services.tailscale.enable = true;
  };
}
