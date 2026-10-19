{
  flake.homeModules.chrome = { pkgs, ...}: {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
