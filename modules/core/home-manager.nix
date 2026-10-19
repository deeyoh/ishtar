{ inputs, lib, ... }: {
  flake.homeManager = system:
    if lib.hasSuffix "-darwin" system then
      inputs.home-manager.darwinModules.home-manager
    else if lib.hasSuffix "-linux" system then
      inputs.home-manager.nixosModules.home-manager
    else
      throw "Unsupported Home Manager platform: ${system}";
}
