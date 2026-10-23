{
  pkgs,
  vars,
  config,
  inputs,
  ...
}:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
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

    searxng = {
      enable = true;
      port = 8888;

      settings = {
        general = {
          instance_name = "Ishtar Search";
          enable_metrics = false;
        };

        search = {
          autocomplete = "duckduckgo";
          safe_search = 0;
          default_lang = "en";
          formats = [ "html" "json" ];
        };

        server = {
          limiter = false;
          public_instance = false;
          image_proxy = true;
        };

        ui = {
          default_theme = "simple";
          query_in_title = true;
          infinite_scroll = false;
        };
      };
    };
  };

  home-manager.users = {
    dio = {
      home.stateVersion = "26.05";
    };

    podman-captain = {
      home.stateVersion = "26.05";
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
