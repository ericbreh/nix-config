{...}: {
  flake.modules.nixos.smartd = {
    pkgs,
    config,
    ...
  }: let
    notifyScript = pkgs.writeShellScript "smartd-notify" ''
      set -euo pipefail
      HC_URL=$(cat ${config.age.secrets.healthchecks-smart.path})
      echo "smartd alert on ${config.networking.hostName}: ''${SMARTD_FULLMESSAGE:-''${SMARTD_MESSAGE:-unknown}}"
      ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
    '';
  in {
    services.smartd = {
      enable = true;
      notifications = {
        wall.enable = false;
        mail.enable = false;
      };
      defaults.monitored = "-a -o on -S on -n standby,q -s (S/../.././03|L/../../7/04) -m <nomailer> -M exec ${notifyScript}";
    };

    # Heartbeat so Healthchecks alerts if the host or smartd stops running.
    systemd.services."smartd-healthchecks-ping" = {
      description = "Healthchecks heartbeat for smartd";
      path = [pkgs.curl pkgs.systemd];
      serviceConfig.Type = "oneshot";
      script = ''
        set -euo pipefail
        HC_URL=$(cat ${config.age.secrets.healthchecks-smart.path})

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start" || true

        if systemctl is-active --quiet smartd; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL" || true
        else
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
          exit 1
        fi
      '';
    };

    systemd.timers."smartd-healthchecks-ping" = {
      description = "Daily Healthchecks heartbeat for smartd";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "04:00";
        Persistent = true;
      };
    };
  };
}
