{ config, ... }: let
  domain = "git.deeyoh.io";
in
{
  # package for cli on path
  environment.systemPackages = [
    config.services.forgejo.package
  ];

  sops.secrets.cloudflare-acme = { };
  services.forgejo = {
    enable = true;

    database.type = "sqlite3";
    lfs.enable = true;

    dump = {
      enable = true;
      type = "tar.zst";
      age = "4w";
    };

    settings = {
      server = {
        DOMAIN = domain;
        ROOT_URL = "https://${domain}/";

        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;

        SSH_DOMAIN = domain;
        SSH_PORT = 22;
      };

      service = {
        DISABLE_REGISTRATION = true;
      };

      session.COOKIE_SECURE = true;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;

      extraConfig = ''
        client_max_body_size 512M;
      '';

      locations."/".proxyPass =
        "http://127.0.0.1:3000";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "er.dioneda@gmail.com";

    certs."git.deeyoh.io" = {
      webroot = null;
      dnsProvider = "cloudflare";
      environmentFile = "/run/secrets/cloudflare-acme";
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
}
