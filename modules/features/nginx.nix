{...}: {
  flake.modules.nixos.nginx = {...}: {
    networking.firewall.allowedTCPPorts = [80 443];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      commonHttpConfig = ''
        limit_req_zone $binary_remote_addr zone=login:10m rate=10r/m;
      '';

      virtualHosts."_" = {
        default = true;
        rejectSSL = true;
        locations."/".return = "404";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "ericchuang94@gmail.com";
    };
  };
}
