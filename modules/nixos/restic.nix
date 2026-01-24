{
  lib,
  config,
  pkgs,
  ...
}: {
  options.restic.enable = lib.mkEnableOption "Enable restic";

  config = lib.mkIf config.restic.enable {
    services.restic.backups.primary = {
      repository = "/srv/backup/restic";
      paths = ["/srv/storage"];
      passwordFile = "/etc/restic-secret";
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
      };
      initialize = true;
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
      backupPrepareCommand = ''
        ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$(cat /etc/healthchecks-restic)/start"
      '';
    };

    systemd.services."restic-backups-primary" = {
      onSuccess = ["restic-notify-success.service"];
      onFailure = ["restic-notify-failure.service"];
    };
    systemd.services."restic-notify-success" = {
      description = "Notify healthchecks.io of successful restic backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $(cat /etc/healthchecks-restic)'";
      };
    };
    systemd.services."restic-notify-failure" = {
      description = "Notify healthchecks.io of failed restic backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $(cat /etc/healthchecks-restic)/fail'";
      };
    };

    systemd.services."restic-check" = {
      description = "Verify restic repository integrity";
      path = [pkgs.restic pkgs.curl];
      environment = {
        RESTIC_REPOSITORY = "/srv/backup/restic";
        RESTIC_PASSWORD_FILE = "/etc/restic-secret";
      };
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        set -euo pipefail
        HC_URL=$(cat /etc/healthchecks-restic-check)

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start"

        if restic check --read-data-subset=10%; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL"
        else
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail"
          exit 1
        fi
      '';
    };

    systemd.timers."restic-check" = {
      description = "Weekly restic repository integrity check";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "Sun 05:00";
        Persistent = true;
      };
    };
  };
}
