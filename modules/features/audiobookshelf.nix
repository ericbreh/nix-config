{...}: {
  flake.modules.nixos.audiobookshelf = {config, ...}: {
    services.audiobookshelf = {
      enable = true;
    };

    services.nginx.virtualHosts."${config.duckdns.domain}.duckdns.org".locations."/audiobookshelf" = {
      proxyPass = "http://127.0.0.1:8000/audiobookshelf";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 10G;
      '';
    };
  };
}
