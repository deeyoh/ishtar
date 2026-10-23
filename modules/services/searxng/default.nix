{
  flake.modules.nixos.searxng = {
    imports = [
      ./service.pkg.nix
    ];
  };
}

