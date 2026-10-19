{ inputs, ... }:
{
  flake.modules.nixos.home-manager =
    inputs.home-manager.nixosModules.home-manager;

  flake.modules.darwin.home-manager =
    inputs.home-manager.darwinModules.home-manager;
}
