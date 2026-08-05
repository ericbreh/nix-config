{...}: {
  flake.modules.nixos.duckdns = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.duckdns.domain = lib.mkOption {
      type = lib.types.str;
    };

    config = {
      systemd.services.duckdns = {
        description = "Update DuckDNS record with current public IP";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        serviceConfig.Type = "oneshot";
        script = ''
          response=$(echo url="https://www.duckdns.org/update?domains=${config.duckdns.domain}&token=$(cat ${config.age.secrets.duckdns.path})&ip=" \
            | ${pkgs.curl}/bin/curl -fsS -K -)
          if [ "$response" != "OK" ]; then
            echo "DuckDNS update failed: $response"
            exit 1
          fi
        '';
      };

      systemd.timers.duckdns = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "1min";
          OnUnitActiveSec = "5min";
        };
      };
    };
  };
}
