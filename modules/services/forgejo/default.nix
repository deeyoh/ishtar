{
  flake.modules.nixos.forgejo = {
    imports = [
      ./serivce.pkg.nix
    ];
  };
}
