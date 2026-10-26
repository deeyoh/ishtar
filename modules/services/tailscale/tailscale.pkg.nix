{ config, inputs, pkgs, ... }: {
  sops.secrets.tailscale-auth-key = { };
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
  };
}
