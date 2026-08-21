{...}: {
  flake.modules.nixos.audiobookshelf = {config, ...}: {
    services.audiobookshelf = {
      enable = true;
    };

    services.nginx = {
      commonHttpConfig = ''
        limit_req_zone $binary_remote_addr zone=audiobookshelf_login:10m rate=10r/m;
      '';

      virtualHosts."${config.duckdns.domain}.duckdns.org" = {
        locations."/audiobookshelf" = {
          proxyPass = "http://127.0.0.1:8000/audiobookshelf";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 10G;
          '';
        };
        locations."/audiobookshelf/login" = {
          proxyPass = "http://127.0.0.1:8000/audiobookshelf/login";
          extraConfig = ''
            limit_req zone=audiobookshelf_login burst=5 nodelay;
          '';
        };
      };
    };
  };
}
