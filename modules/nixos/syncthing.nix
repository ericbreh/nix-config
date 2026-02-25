{
  lib,
  config,
  ...
}: let
  hostName = config.networking.hostName;
in {
  options.syncthing = {
    enable = lib.mkEnableOption "Enable syncthing";
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/home/ericbreh";
    };
  };

  config = lib.mkIf config.syncthing.enable {
    services.syncthing = {
      enable = true;
      user = "ericbreh";
      group = "users";
      dataDir = config.syncthing.dataDir;
      configDir = "/home/ericbreh/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        devices = {
          "titan" = {
            id = "XOGJX6B-MK7S3GQ-ZLOHGFM-T7YX7DJ-M5WN2XI-5LACRNA-BP3ASAZ-L3XO2QI";
          };
          "silver" = {
            id = "OPTPSB6-SKMHQXL-FI7FFE4-5WILIHW-Z6ZQGXM-GCMBHLP-QCA44TQ-FJSCCAC";
          };
        };

        folders = {
          "Pictures" = {
            path = "${config.syncthing.dataDir}/Pictures";
            devices = [
              "titan"
              "silver"
            ];
            ignorePatterns = ["Screenshots"];
            type =
              if hostName == "titan"
              then "sendonly"
              else "receiveonly";
          };
          "Documents" = {
            path = "${config.syncthing.dataDir}/Documents";
            devices = [
              "titan"
              "silver"
            ];
            type =
              if hostName == "titan"
              then "sendonly"
              else "receiveonly";
          };
          "notes" = {
            path = "${config.syncthing.dataDir}/notes";
            devices = [
              "titan"
              "silver"
            ];
            type = "sendreceive";
            fsWatcherEnabled = true;
            fsWatcherDelayS = 1;
            rescanIntervalS = 300;
          };
        };
      };
    };
  };
}
