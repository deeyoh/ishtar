{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        nixd
        nixfmt
        inputs.colmena.packages.${system}.colmena

        (terraform.withPlugins (p: [
          p.null
          p.external
          p.oci
        ]))

        jq
        just
        sops
      ];

      shellHook = ''
        echo "Entered Ishtar Shell..."
      '';
    };
  };
}
