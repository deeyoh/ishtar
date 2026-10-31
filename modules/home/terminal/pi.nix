{ inputs, ... }: {
  flake.modules.homeManager.pi = { pkgs, ... }: {
    imports = [
      inputs.pi-flake.homeManagerModules.default
    ];
    programs.pi-coding-agent = {
      enable = true;
      # The upstream prebuilt Linux binary needs a Nix ELF interpreter/RPATH.
      package = let
        upstream = pkgs.pi or (pkgs.callPackage "${inputs.pi-flake}/package.nix" { });
      in if pkgs.stdenv.hostPlatform.isLinux then
        upstream.overrideAttrs (old: {
          dontStrip = true;
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoPatchelfHook ];
          buildInputs = (old.buildInputs or [ ]) ++ [
            pkgs.stdenv.cc.cc.lib
            pkgs.libxcb
          ];
        })
      else upstream;

      agentFiles = {
        settings = {
          value = {
            defaultProvider = "openai";
            defaultModel = "gpt-6.1-sol";
            theme = "dark";
            defaultProjectTrust = "ask";
          };
        };
      };
    };
  };
}
