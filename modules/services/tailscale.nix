{ pkgs, config, ... }:

let
  waitForTailscale = import ../../utils/wait-for-tailscale.nix { inherit pkgs; };
in
{
  sops.secrets.tailscale-auth-key = {};
  services.tailscale = {
    enable = true;

    authKeyFile = config.sops.secrets.tailscale-auth-key.path;
  };
  systemd.services.tailscale-serve = {
  description = "Configure Tailscale Serve routes";

  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;

    ExecStartPre = [
      "${waitForTailscale}/bin/wait-for-tailscale"
    ];
  };

  script = ''
    ${pkgs.tailscale}/bin/tailscale serve \
      --https=8000 \
      --bg \
      http://127.0.0.1:8000

    ${pkgs.tailscale}/bin/tailscale serve \
      --https=9000 \
      --bg \
      http://127.0.0.1:9000

    ${pkgs.tailscale}/bin/tailscale serve \
      --https=5006 \
      --bg \
      http://127.0.0.1:5006

    ${pkgs.tailscale}/bin/tailscale serve \
      --https=443 \
      --bg \
      http://127.0.0.1:8123

    ${pkgs.tailscale}/bin/tailscale serve \
      --tcp=50051 \
      --bg \
      tcp://127.0.0.1:50051
  '';
};
}
