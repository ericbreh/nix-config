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
        limit_req_status 429;
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
