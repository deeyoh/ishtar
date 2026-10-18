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
          completion = with pkgs.vimPlugins; [
            blink-cmp
            luasnip
            friendly-snippets
            promise-async
          ];

          navigation = with pkgs.vimPlugins; [
            telescope-nvim
            plenary-nvim
            harpoon
          ];

          colorschemes = with pkgs.vimPlugins; [
          ] ++ [
            customColorschemes.miku
          ];

          lazy = with pkgs.vimPlugins; [
            lze
          ];

          lspConfig = with pkgs.vimPlugins; [
            nvim-lspconfig
          ];
        };

        optionalPlugins = {
          tools = with pkgs.vimPlugins; [
            themery-nvim
            oil-nvim
            flash-nvim
            marks-nvim
            nvim-ufo
          ];
        };

        lspsAndRuntimeDeps = {
          tools = with pkgs; [
            ripgrep
            fd
          ];
        };
      };

      packageDefinitions.replace = {
        ishtarNvim = { pkgs, ... }: {
          settings = {
            aliases = [ "vim" "nvim" "vi" "v" ];
          };

          categories = {
            completion = true;
            navigation  =true;
            colorschemes = true;
            lazy = true;
            lspConfig = true;
            tools = true;
          };
        };
      };
    };
  };
}
