{...}: {
  flake.modules.nixos.restic = {
    lib,
    pkgs,
    config,
    ...
  }: let
    hostName = config.networking.hostName;
    hcSecret = job: config.age.secrets."healthchecks-restic-${job}-${hostName}".path;
    localRepo = "/srv/backup/restic";
    offsiteHost = "silver";
    offsiteRepo = "sftp:${config.mainUser}@${offsiteHost}:/srv/backup/restic";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
      "--keep-yearly unlimited"
    ];
  in {
    programs.fuse.enable = true;

    programs.ssh.knownHosts.${offsiteHost}.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdX2ZGu+vzz7td6aKvsb2rrb14S3cBdc32ds3dPfrWm";

    services.restic.backups.local = {
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
        ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$(cat ${hcSecret "local"})/start" || true
      '';
      backupCleanupCommand = ''
        HC_URL=$(cat ${hcSecret "local"})
        if [ "$SERVICE_RESULT" = success ]; then
          ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL" || true
        else
          ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
        fi
      '';
    };

    systemd.services."restic-backups-local" = {
      onSuccess = ["restic-offsite.service"];
      unitConfig.RequiresMountsFor = ["/srv/storage" "/srv/backup"];
    };

    systemd.services."restic-offsite" = {
      description = "Copy restic snapshots to the offsite repo on ${offsiteHost}";
      path = [pkgs.restic pkgs.curl pkgs.openssh pkgs.coreutils];
      restartIfChanged = false;
      environment = {
        RESTIC_REPOSITORY = offsiteRepo;
        RESTIC_PASSWORD_FILE = config.age.secrets.restic.path;
        RESTIC_CACHE_DIR = "/var/cache/restic-offsite";
      };
      serviceConfig = {
        Type = "oneshot";
        CacheDirectory = "restic-offsite";
      };
      unitConfig.RequiresMountsFor = ["/srv/backup"];
      script = ''
        set -euo pipefail
        HC_URL=$(cat ${hcSecret "offsite"})
        sftpArgs="-i ${config.age.secrets.restic-offsite-ssh.path} -o IdentitiesOnly=yes"

        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start" || true

        if ! restic -o sftp.args="$sftpArgs" cat config >/dev/null; then
          echo "Offsite repo unreachable or missing; refusing to init" >&2
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
          exit 1
        fi

        echo "Copying snapshots to offsite repo on ${offsiteHost}"
        if ! restic -o sftp.args="$sftpArgs" copy \
          --from-repo ${localRepo} \
          --from-password-file ${config.age.secrets.restic.path}; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail" || true
          exit 1
        fi

        echo "Pruning ${hostName} snapshots in offsite repo"
        if ! restic -o sftp.args="$sftpArgs" forget --prune \
          --host ${hostName} \
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
        HC_URL=$(cat ${hcSecret "check"})

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
