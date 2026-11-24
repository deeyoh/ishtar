{ inputs, ... }: {
  flake.modules.homeManager.tuxedo = { pkgs, ... }: let
    # currently tuxedo available through unstable, but systems on 26.05
    unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    home.packages = [ unstable.tuxedo ];
  };
}
