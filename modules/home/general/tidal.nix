{
  flake.modules.darwin.tidal = {
    homebrew = {
      enable = true;
      casks = [ "tidal" ];
    };
  };
}
