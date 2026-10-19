{
  flake.modules.homeManager.ghostty = { pkgs, ... }: {
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
        confirm-close-surface = false;
        keybind = [
          "ctrl+s>h=goto_split:left"
          "ctrl+s>l=goto_split:right"
          "ctrl+s>j=goto_split:down"
          "ctrl+s>k=goto_split:up"

          "ctrl+s>z=toggle_split_zoom"
          "ctrl+s>e=equalize_splits"
          "ctrl+s>x=close_surface"

          "ctrl+s>c=new_tab"
          "ctrl+s>n=next_tab"
          "ctrl+s>b=previous_tab"

          "ctrl+s>one=goto_tab:1"
          "ctrl+s>two=goto_tab:2"
          "ctrl+s>three=goto_tab:3"
          "ctrl+s>four=goto_tab:4"
          "ctrl+s>five=goto_tab:5"
          "ctrl+s>six=goto_tab:6"
          "ctrl+s>seven=goto_tab:7"
          "ctrl+s>eight=goto_tab:8"
          "ctrl+s>nine=goto_tab:9"

          "ctrl+s>shift+backslash=new_split:right"
          "ctrl+s>minus=new_split:down"

          "ctrl+s>period=prompt_surface_title"
        ];
      };
    };
  };
}
