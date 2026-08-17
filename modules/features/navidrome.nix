{...}: {
  flake.modules.nixos.navidrome = {config, ...}: {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "127.0.0.1";
        MusicFolder = "/srv/storage/media/music";
      };
    };

    services.nginx = {
      commonHttpConfig = ''
        limit_req_zone $binary_remote_addr zone=navidrome_login:10m rate=10r/m;
        limit_req_zone $binary_remote_addr zone=navidrome_subsonic:10m rate=5r/s;
      '';

      virtualHosts."${config.duckdns.domain}.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000" always;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:4533";
          proxyWebsockets = true;
        };
        locations."/auth/" = {
          proxyPass = "http://127.0.0.1:4533";
          extraConfig = ''
            limit_req zone=navidrome_login burst=5 nodelay;
          '';
        };
        locations."/rest/" = {
          proxyPass = "http://127.0.0.1:4533";
          extraConfig = ''
            limit_req zone=navidrome_subsonic burst=30 nodelay;
          '';
        };
      };
    };
  };
}
