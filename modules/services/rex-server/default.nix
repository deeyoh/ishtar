{ inputs, ... }: {
  flake.modules.nixos.rex-server = {
    imports = [
      inputs.rex.nixosModules.default
      ./service.pkg.nix
    ];
  };
}
