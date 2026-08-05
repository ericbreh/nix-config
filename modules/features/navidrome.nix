{...}: {
  flake.modules.nixos.navidrome = {config, ...}: {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "127.0.0.1";
        MusicFolder = "/srv/storage/media/music";
      };
    };

    services.nginx.virtualHosts."${config.duckdns.domain}.duckdns.org" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4533";
        proxyWebsockets = true;
      };
      locations."/auth/" = {
        proxyPass = "http://127.0.0.1:4533";
        extraConfig = ''
          limit_req zone=login burst=5 nodelay;
        '';
      };
    };
  };
}
