{
  flake.darwinModules.discord = {
    homebrew = {
      enable = true;
      casks = [ "discord" ];
    };
  };
}
