{
  flake.modules.nixos.podman = { pkgs, ... }: {
    virtualisation.podman = {
      dockerCompat = true;
      defaultNetwork.settings = { dns_enabled = true; };
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
