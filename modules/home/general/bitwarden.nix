{ config, ... }: {
  # install bitwarden via desktop due to GUI issues
  # when installing via home manager (same for discord)
  flake.darwinModules.bitwarden = {
    homebrew = {
      enable = true;
      casks = [ "bitwarden" ];
    };
  };

  flake.nixosModules.bitwarden = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];
  };

  flake.homeModules.bitwarden-ssh = { config, ... }: {
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

  # for linux, only need to import `config.flake.homeModules.bitwarden`,
  # macos requires a separate darwin module + the defined `bitwarden-ssh` module
  flake.homeModules.bitwarden = { pkgs, ... }: {
    imports = [
      config.flake.homeModules.bitwarden-ssh
    ];

    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
