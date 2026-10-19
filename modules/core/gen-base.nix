{ inputs, ... }: {
  flake.modules.nixos.gen-base = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
    ];
  };
}
