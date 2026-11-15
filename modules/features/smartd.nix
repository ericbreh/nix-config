{...}: {
  flake.modules.nixos.smartd = {
    pkgs,
    config,
    ...
  }: let
    hostName = config.networking.hostName;
    hcSecret = config.age.secrets."healthchecks-smartd-${hostName}";
    alertFile = "/var/lib/smartd-alert";
    notifyScript = pkgs.writeShellScript "smartd-notify" ''
      set -euo pipefail
      HC_URL=$(cat ${hcSecret.path})
      msg="smartd alert on ${hostName}: ''${SMARTD_FULLMESSAGE:-''${SMARTD_MESSAGE:-unknown}}"
      echo "$msg"
      echo "$(date -Is) $msg" >> ${alertFile}
      ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null --data-raw "$msg" "$HC_URL/fail" || true
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

    systemd.services."smartd-ping" = {
      description = "Healthchecks heartbeat for smartd";
      path = [pkgs.curl pkgs.systemd];
      serviceConfig.Type = "oneshot";
      script = ''
        set -euo pipefail
        HC_URL=$(cat ${hcSecret.path})

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start" || true

        if [ -e ${alertFile} ]; then
          echo "Unresolved smartd alert; delete ${alertFile} once handled:" >&2
          cat ${alertFile} >&2
          curl -fsS -m 10 --retry 5 -o /dev/null --data-binary @${alertFile} "$HC_URL/fail" || true
          exit 1
        elif systemctl is-active --quiet smartd; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL" || true
        else
          curl -fsS -m 10 --retry 5 -o /dev/null --data-raw "smartd is not running" "$HC_URL/fail" || true
          exit 1
        fi
      '';
    };

    systemd.timers."smartd-ping" = {
      description = "Daily Healthchecks heartbeat for smartd";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "04:00";
        Persistent = true;
      };
    };
  };
}
