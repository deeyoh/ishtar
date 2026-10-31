{
  config,
  lib,
  inputs,
  ishtarUtils,
  ...
}:
let
  cfg = config.services.homeassistant;
in
{
  options.services.homeassistant = {

    enable = lib.mkEnableOption "homeassistant";
    image = lib.mkOption {
      type = lib.types.str;
      default = "homeassistant/home-assistant:stable";
    };
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="tty", KERNEL=="ttyUSB*", ATTRS{serial}=="ee14bc1d4329f111bc2a40adfa551895", OWNER="podman-captain", MODE="0600"
    '';

    # sops.templates."homeassistant-labels" = {
    #   owner = "podman-captain";
    #   group = "podman-captain";
    #   mode = "0400";
    #
    #   content = ''
    #     redjaxk.name=Home Assistant
    #     redjaxk.url=https://${config.networking.hostName}.${config.sops.placeholder.tailscale-domain}
    #   '';
    # };
    systemd.tmpfiles.rules = [
      "d /var/lib/podman-captain/homeassistant 0750 podman-captain podman-captain -"
    ];

    home-manager.users.podman-captain = {
      imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

      virtualisation.quadlet.containers.homeassistant = {
        autoStart = cfg.autoStart;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";

          ExecStartPre = [ "${ishtarUtils.waitForTailscale}/bin/wait-for-tailscale" ];
        };

        containerConfig = {
          image = cfg.image;
          # podmanArgs = [
          #   "--label-file=${config.sops.templates."homeassistant-labels".path}"
          # ];
          #@NOTE: On initial setup, reverse proxy must be set up within the UI.
          #       First load the initial server and then imperatively change it via UI.
          publishPorts = [ "127.0.0.1:8123:8123" ];
          userns = "keep-id";
          devices = [
            "/dev/serial/by-id/usb-Silicon_Labs_CP2102N_USB_to_UART_Bridge_Controller_ee14bc1d4329f111bc2a40adfa551895-if00-port0:/dev/ttyUSB0"
          ];

          volumes = [
            "/var/lib/podman-captain/homeassistant:/config"
          ];
        };
      };
    };
  };
}
