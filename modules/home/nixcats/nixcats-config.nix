{ inputs, ... }:

let
  utils = inputs.nixCats.utils;
in
{
  imports = [
    inputs.nixCats.homeModule
  ];

  config = {
    nixCats = {
      enable = true;
      packageNames = [ "ishtarNvim" ];
      luaPath = ./nvim;
      addOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions.replace = { pkgs, ... }: 
      let
        customColorschemes = import ./colorschemes.nix {
          inherit pkgs;
        };
      in
      {
        startupPlugins = {
          colorschemes = with pkgs.vimPlugins; [
          ] ++ [
            customColorschemes.miku
          ];
        };
      };

      packageDefinitions.replace = {
        ishtarNvim = { pkgs, ... }: {
          settings = {
            aliases = [ "vim" "nvim" "vi" "v" ];
          };

          categories = {
            colorschemes = true;
          };
        };
      };
    };
  };
}
