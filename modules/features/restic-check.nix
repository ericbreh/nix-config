{...}: {
  flake.modules.nixos.restic-check = {
    pkgs,
    config,
    ...
  }: let
    hostName = config.networking.hostName;
  in {
    systemd.services."restic-check" = {
      description = "Verify restic repository integrity";
      path = [pkgs.restic pkgs.curl pkgs.coreutils];
      environment = {
        RESTIC_REPOSITORY = "/srv/backup/restic";
        RESTIC_PASSWORD_FILE = config.age.secrets.restic.path;
      };
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig.RequiresMountsFor = ["/srv/backup"];
      script = ''
        set -euo pipefail
        HC_URL=$(cat ${config.age.secrets."healthchecks-restic-check-${hostName}".path})

        WEEK=$(date +%-V)
        SUBSET=$(( (WEEK - 1) % 10 + 1 ))

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start" || true

        echo "Running restic check --read-data-subset=''${SUBSET}/10 (ISO week ''${WEEK})"
        if restic check --retry-lock 2h --read-data-subset="''${SUBSET}/10"; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL" || true
        else
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
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
