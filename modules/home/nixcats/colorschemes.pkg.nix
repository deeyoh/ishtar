{ pkgs }: {
  miku = pkgs.vimUtils.buildVimPlugin {
    pname = "miku.nvim";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "4513ECHO";
      repo = "vim-colors-hatsunemiku";
      rev = "eecb0f1fe4db10c312a8174d758ba275a8e95736";
      hash = "sha256-SwY4uWql/scDe0qCq7PoPucYdNlRvLzpx8+txsfi71U=";
    };
  };
}
