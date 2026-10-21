let
  domain = "git.deeyoh.io";
in
{
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
        DISABLE_REGISTRATION = false;
      };

      session.COOKIE_SECURE = true;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts = {
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
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
}
