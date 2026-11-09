{...}: {
  flake.modules.nixos.immich = {config, ...}: {
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      mediaLocation = "/srv/storage/immich";
    };

    services.nginx = {
      commonHttpConfig = ''
        limit_req_zone $binary_remote_addr zone=immich_login:10m rate=10r/m;
      '';

      virtualHosts."immich.${config.duckdns.domain}.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "same-origin" always;
          add_header X-Frame-Options "SAMEORIGIN" always;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_request_buffering off;
            client_body_buffer_size 1024k;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout 600s;
          '';
        };
        locations."= /api/auth/login" = {
          proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
          extraConfig = ''
            limit_req zone=immich_login burst=5 nodelay;
          '';
        };
      };
    };

    services.fail2ban = {
      enable = true;
      jails.immich = {
        filter.Definition = {
          failregex = "Failed login attempt for user .+ from ip address <ADDR>";
          journalmatch = "_SYSTEMD_UNIT=immich-server.service";
        };
        settings = {
          port = "http,https";
          maxretry = 5;
          bantime = "1h";
        };
      };
    };
  };
}
