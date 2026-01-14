{
  lib,
  config,
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
    };
  };
}
