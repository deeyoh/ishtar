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
  };

  services = {
    fast-note-sync.enable = true;
    homeassistant.enable = true;
  };

  home-manager.users.dio = {
    home.stateVersion = "26.05";
    imports = [ inputs.redjaxk.homeManagerModules.default ];

    services.redjaxk-agent = {
      enable = false;
      environment.REDJAXK_NODE_ID = "ishtar-1";
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
