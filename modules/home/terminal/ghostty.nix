{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;

    settings = {
      font-size = 16;
      cursor-style = "block";
      background-opacity = 0.7;
      background-blur = true;
    };
  };
}
