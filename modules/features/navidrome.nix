{...}: {
  flake.modules.nixos.navidrome = {config, ...}: {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "127.0.0.1";
        BaseURL = "/music";
        MusicFolder = "/srv/storage/media/music";
      };
    };

    services.nginx = {
      commonHttpConfig = ''
        limit_req_zone $binary_remote_addr zone=navidrome_login:10m rate=10r/m;
        limit_req_zone $binary_remote_addr zone=navidrome_subsonic:10m rate=5r/s;
      '';

      virtualHosts."${config.duckdns.domain}.duckdns.org" = {
        locations."/music" = {
          proxyPass = "http://127.0.0.1:4533/music";
          proxyWebsockets = true;
        };
        locations."/music/auth/" = {
          proxyPass = "http://127.0.0.1:4533/music/auth/";
          extraConfig = ''
            limit_req zone=navidrome_login burst=5 nodelay;
          '';
        };
        locations."/music/rest/" = {
          proxyPass = "http://127.0.0.1:4533/music/rest/";
          extraConfig = ''
            limit_req zone=navidrome_subsonic burst=30 nodelay;
          '';
        };
      };
    };
  };
}
