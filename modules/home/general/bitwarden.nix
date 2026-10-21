{ config, ... }: {
  # install bitwarden via desktop due to GUI issues
  # when installing via home manager (same for discord)
  flake.modules.darwin.bitwarden = {
    homebrew = {
      enable = true;
      casks = [ "bitwarden" ];
    };
  };

  flake.modules.nixos.bitwarden = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];
  };

  flake.modules.homeManager.bitwarden-ssh = { config, ... }: let
    identityAgent = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  in {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
        };

        "git.deeyoh.io" = {
          user = "forgejo";
          identityAgent = identityAgent;
          identityFile = "~/.ssh/bitwarden_forgejo.pub";
          identitiesOnly = true;
        };

        "ishtar1" = {
          user = "dio";
          identityAgent = identityAgent;
        };
      };
    };
  };

  # for linux, only need to import `config.flake.modules.homeManager.bitwarden`,
  # macos requires a separate darwin module + the defined `bitwarden-ssh` module
  flake.modules.homeManager.bitwarden = { pkgs, ... }: {
    imports = [
      config.flake.modules.homeManager.bitwarden-ssh
    ];

    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
