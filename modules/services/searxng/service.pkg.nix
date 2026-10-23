{ pkgs, config, lib, inputs, ishtarUtils, ... }: let
  cfg = config.services.searxng;
  yaml = pkgs.formats.yaml { };

  settingsFile = yaml.generate "searxng-settings.yml" (
    lib.recursiveUpdate {
      use_default_settings = true;

      general = {
        instance_name = "SearXNG";
        debug = false;
      };

      search = {
        safe_search = 0;
        autocomplete = "duckduckgo";
        formats = [ "html" "json" ];
      };

      server = {
        limiter = false;
        public_instance = false;
        image_proxy = true;
      };
    } cfg.settings
  );
in
{
  options.services.searxng = {
    sops.secrets.searxng-secret = { };
    sops.templates."searxng.env" = {
      owner = "podman-captain";
      group = "podman-captain";
      mode = "0400";

      content = ''
        SEARXNG_SECRET=${config.sops.placeholder.searxng-secret}
      '';
    };
    enable = lib.mkEnableOption "searxng";
    image = lib.mkOption {
      type = lib.types.str;
      default = "searxng/searxng:latest";
    };
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
    };

    settings = lib.mkOption {
      type = yaml.type;
      default = { };
      description = "SearXNG settings.yml configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /var/lib/podman-captain/searxng 0750 podman-captain podman-captain -"
      "d /var/lib/podman-captain/searxng/cache 0750 podman-captain podman-captain -"
    ];

    home-manager.users.podman-captain = {
      imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

      virtualisation.quadlet.containers.searxng = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";

          ExecStartPre = [
            "${ishtarUtils.waitForTailscale}/bin/wait-for-tailscale"
          ];
        };

        containerConfig = {
          image = cfg.image ;
          publishPorts = [ "127.0.0.1:${toString cfg.port}:8888" ];
          userns = "keep-id";

          volumes = [
            "${settingsFile}:/etc/searxng/settings.yml:ro"
            "/var/lib/podman-captain/searxng/cache:/var/cache/searxng"
          ];

          environments = {
            FORCE_OWNERSHIP = "false";
          };

          environmentFiles = [
            config.sops.templates."searxng.env".path
          ];
        };
      };
    };
  };
}
