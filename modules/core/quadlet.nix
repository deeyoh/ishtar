{ inputs, ... }: {
  flake.nixosModules.quadlet = {
    imports = [
      inputs.quadlet-nix.nixosModules.quadlet
    ];
  };
}
