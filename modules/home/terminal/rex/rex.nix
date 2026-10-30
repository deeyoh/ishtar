{
  flake.modules.homeManager.rex = { pkgs, ... }: {
    xdg.configFile."rex/init.lua".source = ./init.lua;
  };
}
