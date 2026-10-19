{ inputs, ... }: {
  flake.modules.nixos.quadlet = {
    imports = [
      inputs.quadlet-nix.nixosModules.quadlet
    ];
  };
}
