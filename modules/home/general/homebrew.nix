{ inputs, pkgs, ... }: {
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  
  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = "dio";
    mutableTaps = false;
  };
}
