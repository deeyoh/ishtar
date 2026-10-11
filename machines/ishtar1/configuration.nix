{
  pkgs,
  vars,
  config,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/nixos/base.nix

    ../../modules/services/tailscale.nix

    ../../modules/services/vault-warden
    ../../modules/services/minecraft

    ../../modules/services/containers

    ./disko.nix
    ./hardware-configuration.nix

    # === SERVICE MODULES ===
    ../../modules/services/fast-note-sync
    ../../modules/services/homeassistant
    ../../modules/services/actual-budget
  ];

  networking.hostName = "ishtar1";

  sops = {
    defaultSopsFile = ../../secrets/ishtar-secrets.yaml;
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets.dio-password = {
      neededForUsers = true;
    };
    secrets.wireguard-ishtar1-private-key = { };
    secrets.tailscale-domain = { };
  };

  services = {
    fast-note-sync.enable = true;
    homeassistant.enable = true;
    actual-budget.enable = true;
  };

  users.groups.redjaxk-ipc = { };
  users.users = {
    ${vars.userName} = {
      extraGroups = [
        "redjaxk-ipc"
      ];
      linger = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /run/redjaxk 2750 podman-captain redjaxk-ipc -"
  ];

  home-manager.users = {
    dio = {
      home.stateVersion = "26.05";
      imports = [ inputs.redjaxk.homeManagerModules.default ];

      services.redjaxk-agent = {
        enable = true;
        environment.REDJAXK_NODE_ID = "ishtar-1";
      };
    };

    podman-captain = {
      home.stateVersion = "26.05";
      imports = [ inputs.redjaxk.homeManagerModules.default ];

      services.redjaxk-podgate.enable = true;
      systemd.user.services.redjaxk-podgate.Service.Environment = [
        "PATH=${pkgs.lib.makeBinPath [ pkgs.podman ]}"
      ];
    };
  };

  networking = {
    firewall = {
      allowedUDPPorts = [
        51820
        24454
      ];
      allowedTCPPorts = [ 25565 ];
      interfaces.wg-edge0.allowedTCPPorts = [ 25565 ];
    };

    wireguard.interfaces = {
      wg-edge0 = {
        ips = [ "10.100.0.2/24" ];
        listenPort = 51820;

        privateKeyFile = config.sops.secrets.wireguard-ishtar1-private-key.path;

        peers = [
          {
            publicKey = vars.wireGuardPublicKeyIshtarEdge;
            allowedIPs = [ "10.100.0.1/32" ];
            endpoint = "129.213.155.190:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
