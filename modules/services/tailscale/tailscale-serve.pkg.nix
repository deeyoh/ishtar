{ config, ishtarUtils, ... }: {
  systemd.services.tailscale-serve = {
    description = "Configure Tailscale Serve routes";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStartPre = [
        "${ishtarUtils.waitForTailscale}/bin/wait-for-tailscale"
      ];
    };

    script = ''
      ${config.services.tailscale.package}/bin/tailscale serve \
        --https=8000 \
        --bg \
        http://127.0.0.1:8000

      ${config.services.tailscale.package}/bin/tailscale serve \
        --https=9000 \
        --bg \
        http://127.0.0.1:9000

      ${config.services.tailscale.package}/bin/tailscale serve \
        --https=5006 \
        --bg \
        http://127.0.0.1:5006

      ${config.services.tailscale.package}/bin/tailscale serve \
        --https=8443 \
        --bg \
        http://127.0.0.1:8123

      ${config.services.tailscale.package}/bin/tailscale serve \
        --tcp=50051 \
        --bg \
        tcp://127.0.0.1:50051

      ${config.services.tailscale.package}/bin/tailscale serve \
        --https=8888 \
        --bg \
        http://127.0.0.1:8888
    '';
  };
}
