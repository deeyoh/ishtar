{ lib, ... }:
let
  workspaces = map toString (lib.range 1 9);
in
{
  flake.homeModules.aerospace = {
    programs.aerospace = {
      enable = true;

      launchd.enable = true;

      settings = {
        mode.main.binding = {
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-comma = "focus-monitor left";
          alt-period = "focus-monitor right";
        }
        // builtins.listToAttrs (
          map (ws: {
            name = "alt-${ws}";
            value = "workspace ${ws}";
          }) workspaces
        )
        // builtins.listToAttrs (
          map (ws: {
            name = "alt-shift-${ws}";
            value = "move-node-to-workspace ${ws}";
          }) workspaces
        );
      };
    };
  };
}
