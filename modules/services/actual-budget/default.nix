{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.services.actual-budget;
  waitForTailscale = import ../../../utils/wait-for-tailscale.nix { inherit pkgs; };
in
{
  options.services.actual-budget = {
    enable = lib.mkEnableOption "actual-budget";
    image = lib.mkOption {
      type = lib.types.str;
      default = "actualbudget/actual-server:latest";
    };
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.templates."actual-budget-labels" = {
      owner = "podman-captain";
      group = "podman-captain";
      mode = "0400";

      content = ''
        redjaxk.name=Actual Budget
        redjaxk.url=https://${config.networking.hostName}.${config.sops.placeholder.tailscale-domain}:5006
      '';
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/podman-captain/actual-budget 0750 podman-captain podman-captain -"
      "d /var/lib/podman-captain/actual-budget/data 0750 podman-captain podman-captain -"
    ];

    home-manager.users.podman-captain = {
      imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

      virtualisation.quadlet.containers.actual-budget = {
        autoStart = cfg.autoStart;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";

          ExecStartPre = [ "${waitForTailscale}/bin/wait-for-tailscale" ];
        };

        containerConfig = {
          image = cfg.image;
          podmanArgs = [
            "--label-file=${config.sops.templates."actual-budget-labels".path}"
          ];
          publishPorts = [ "127.0.0.1:5006:5006" ];
          userns = "keep-id";

          volumes = [
            "/var/lib/podman-captain/actual-budget/data:/data"
          ];
        };
      };
    };
  };
}
