{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.services.fast-note-sync;
  waitForTailscale = import ../../../utils/wait-for-tailscale.nix { inherit pkgs; };
in
{
  options.services.fast-note-sync = {
    enable = lib.mkEnableOption "fast-note-sync";
    enableRedjaxkDiscovery = lib.mkEnableOption "Redjaxk discovery labels";
    image = lib.mkOption {
      type = lib.types.str;
      default = "haierkeys/fast-note-sync-service:latest";
    };
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      systemd.tmpfiles.rules = [
        "d /var/lib/podman-captain/fast-note-sync 0750 podman-captain podman-captain -"
        "d /var/lib/podman-captain/fast-note-sync/storage 0750 podman-captain podman-captain -"
        "d /var/lib/podman-captain/fast-note-sync/config 0750 podman-captain podman-captain -"
      ];
      home-manager.users.podman-captain = {
        imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

        virtualisation.quadlet.containers.fast-note-sync = {
          autoStart = cfg.autoStart;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";

            ExecStartPre = [ "${waitForTailscale}/bin/wait-for-tailscale" ];
          };

          containerConfig = {
            image = cfg.image;
            podmanArgs = lib.options cfg.enableRedjaxkDiscovery [
              "--label-file=${config.sops.templates."notesync-labels".path}"
            ];
            publishPorts = [ "127.0.0.1:9000:9000" ];
            userns = "keep-id";

            volumes = [
              "/var/lib/podman-captain/fast-note-sync/storage:/fast-note-sync/storage"
              "/var/lib/podman-captain/fast-note-sync/config:/fast-note-sync/config"
            ];
          };
        };
      };
    })

    (lib.mkIf (cfg.enable && cfg.enableRedjaxkDiscovery) {
      sops.templates."notesync-labels" = {
        owner = "podman-captain";
        group = "podman-captain";
        mode = "0400";

        content = ''
          redjaxk.name=Fast Note Sync
          redjaxk.url=https://${config.networking.hostName}.${config.sops.placeholder.tailscale-domain}:9000
        '';
      };
    })
  ];
}
