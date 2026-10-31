{ config, ... }: let
  vars = import ../../../vars.nix;
  home_bitwarden_forgejo_public_key_path = ".ssh/bitwarden_forgejo.pub";
  bitwarden_forgejo_public_key_path = "~/${home_bitwarden_forgejo_public_key_path}";
in {
  # install bitwarden via desktop due to GUI issues
  # when installing via home manager (same for discord)
  flake.modules.darwin.bitwarden = {
    homebrew = {
      enable = true;
      casks = [ "bitwarden" ];
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

  # linux desktop app install
  flake.modules.nixos.bitwarden = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];
  };

  # configures the SSH for user facing machines
  flake.modules.homeManager.bitwarden-ssh = { config, ... }: let
    identityAgent = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  in {
    home.file.${home_bitwarden_forgejo_public_key_path}.text =
      vars.bw_sshSharedForgejoPubKey;
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
          identityFile = bitwarden_forgejo_public_key_path;
          identitiesOnly = true;
        };

        "ishtar1" = {
          user = "dio";
          identityAgent = identityAgent;
          identityFile = "~/.ssh/ishtar1.pub";
          identitiesOnly = true;
        };

        "ishtar1-ssh-agent" = {
          hostName = "ishtar1";
          user = "dio";
          identityAgent = identityAgent;
          identityFile = "~/.ssh/ishtar1.pub";
          identitiesOnly = true;
          remoteForward = "/home/dio/.ssh/bitwarden-forward.sock ${identityAgent}";
          exitOnForwardFailure = true;
        };
      };
    };
  };

  # Servers use the agent forwarded from a user-facing machine.
  flake.modules.homeManager.forwarded-ssh-agent = { config, ... }: {
    home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.ssh/bitwarden-forward.sock";

    home.file.${home_bitwarden_forgejo_public_key_path}.text =
      vars.bw_sshSharedForgejoPubKey;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."git.deeyoh.io" = {
        user = "forgejo";
        identityFile = bitwarden_forgejo_public_key_path;
        identitiesOnly = true;
        # No identityAgent override: SSH uses SSH_AUTH_SOCK.
      };
    };
  };
}
