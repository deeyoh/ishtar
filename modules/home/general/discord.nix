{
  flake.modules.darwin.discord = {
    homebrew = {
      enable = true;
      casks = [ "discord" ];
    };
  };
}
