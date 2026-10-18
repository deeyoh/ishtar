{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;

    settings = {
      font-size = 16;
      cursor-style = "block";
      background-opacity = 0.8;
      background-blur = true;
      theme = "HaX0R Blue";
    };
  };
}
