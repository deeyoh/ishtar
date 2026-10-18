{ lib, options, pkgs, ... }:

lib.mkMerge [
  (lib.optionalAttrs (options ? homebrew) {
    homebrew.casks = [ "bitwarden" ];
  })

  (lib.optionalAttrs (options ? services && options.services ? xserver) {
    environment.systemPackages = [
      pkgs.bitwarden-desktop
    ];
  })

  (lib.optionalAttrs (options ? home-manager) {
    home-manager.users.dio = { config, pkgs, ... }: {
      programs.ssh = {
        enable = true;

        matchBlocks = {
          "github.com" = { 
            identityFile = "~/.ssh/id_ed25519";
          };

          "ishtar1" = {
            user = "dio";
            identityAgent =
              "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
          };
        };
      };
    };
  })
]
