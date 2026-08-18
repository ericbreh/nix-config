{...}: {
  flake.modules.nixos.nginx = {config, ...}: {
    networking.firewall.allowedTCPPorts = [80 443];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      commonHttpConfig = ''
        limit_req_status 429;
      '';

      virtualHosts = {
        "_" = {
          default = true;
          rejectSSL = true;
          locations."/".return = "404";
        };
        "${config.duckdns.domain}.duckdns.org" = {
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
            add_header Strict-Transport-Security "max-age=31536000" always;
          '';
          locations."/".return = "404";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "ericchuang94@gmail.com";
    };
  };
}
