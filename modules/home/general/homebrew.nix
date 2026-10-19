{ inputs, ... }: {
  flake.modules.darwin.homebrew = {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
    
    nix-homebrew = {
      enable = true;
      enableRosetta = false;
      user = "dio";
      mutableTaps = false;
    };
    homebrew.enable = true;
  };
}
