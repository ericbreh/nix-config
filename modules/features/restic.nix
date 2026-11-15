{...}: {
  flake.modules.nixos.restic = {
    lib,
    pkgs,
    config,
    ...
  }: let
    localRepo = "/srv/backup/restic";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
      "--keep-yearly unlimited"
    ];
  in {
    programs.fuse.enable = true;

    services.restic.backups.primary = {
      repository = localRepo;
      paths = ["/srv/storage"];
      passwordFile = config.age.secrets.restic.path;
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
      };
      initialize = true;
      inherit pruneOpts;
      backupPrepareCommand = ''
        ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$(cat ${config.age.secrets.healthchecks-restic.path})/start" || true
      '';
    };

    systemd.services."restic-backups-primary" = {
      onSuccess = [
        "restic-notify-success.service"
        "restic-copy-silver.service"
      ];
      onFailure = ["restic-notify-failure.service"];
      unitConfig.RequiresMountsFor = ["/srv/storage" "/srv/backup"];
    };
    systemd.services."restic-notify-success" = {
      description = "Notify healthchecks.io of successful restic backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $(cat ${config.age.secrets.healthchecks-restic.path})'";
      };
    };
    systemd.services."restic-notify-failure" = {
      description = "Notify healthchecks.io of failed restic backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $(cat ${config.age.secrets.healthchecks-restic.path})/fail'";
      };
    };

    systemd.services."restic-copy-silver" = {
      description = "Copy restic snapshots from rhea local repo to silver";
      path = [pkgs.restic pkgs.curl pkgs.openssh pkgs.coreutils];
      environment = {
        RESTIC_REPOSITORY = "sftp:${config.mainUser}@silver:/srv/backup/restic";
        RESTIC_PASSWORD_FILE = config.age.secrets.restic.path;
        RESTIC_CACHE_DIR = "/var/cache/restic-copy-silver";
      };
      serviceConfig = {
        Type = "oneshot";
        CacheDirectory = "restic-copy-silver";
      };
      unitConfig.RequiresMountsFor = ["/srv/backup"];
      script = ''
        set -euo pipefail
        HC_URL=$(cat ${config.age.secrets.healthchecks-restic-offsite.path})
        sftpArgs="-i ${config.age.secrets.restic-silver-ssh.path} -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start" || true

        if ! restic -o sftp.args="$sftpArgs" cat config >/dev/null; then
          echo "Remote repo unreachable or missing; refusing to init (use existing /srv/backup/restic on silver)" >&2
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
          exit 1
        fi

        echo "Copying snapshots to silver"
        if ! restic -o sftp.args="$sftpArgs" copy \
          --from-repo ${localRepo} \
          --from-password-file ${config.age.secrets.restic.path}; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
          exit 1
        fi

        echo "Pruning ${config.networking.hostName} snapshots on silver"
        if ! restic -o sftp.args="$sftpArgs" forget --prune \
          --host ${config.networking.hostName} \
          ${lib.concatStringsSep " " pruneOpts}; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
          exit 1
        fi

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL" || true
      '';
    };

    systemd.services."restic-check" = {
      description = "Verify restic repository integrity";
      path = [pkgs.restic pkgs.curl pkgs.coreutils];
      environment = {
        RESTIC_REPOSITORY = localRepo;
        RESTIC_PASSWORD_FILE = config.age.secrets.restic.path;
      };
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig.RequiresMountsFor = ["/srv/backup"];
      script = ''
        set -euo pipefail
        HC_URL=$(cat ${config.age.secrets.healthchecks-restic-check.path})

        WEEK=$(date +%-V)
        SUBSET=$(( (WEEK - 1) % 10 + 1 ))

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start" || true

        echo "Running restic check --read-data-subset=''${SUBSET}/10 (ISO week ''${WEEK})"
        if restic check --read-data-subset="''${SUBSET}/10"; then
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
