{...}: {
  flake.modules.nixos.syncthing = {
    lib,
    config,
    ...
  }: let
    hostName = config.networking.hostName;
  in {
    options.syncthing.dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/home/${config.mainUser}";
    };

    config = {
      networking.firewall.interfaces."tailscale0" = {
        allowedTCPPorts = [22000];
        allowedUDPPorts = [22000 21027];
      };

      services.syncthing = {
        enable = true;
        user = config.mainUser;
        group = "users";
        dataDir = config.syncthing.dataDir;
        configDir = "/home/${config.mainUser}/.config/syncthing";
        openDefaultPorts = false;

        settings = {
          devices = {
            "titan" = {
              id = "XOGJX6B-MK7S3GQ-ZLOHGFM-T7YX7DJ-M5WN2XI-5LACRNA-BP3ASAZ-L3XO2QI";
            };
            "rhea" = {
              id = "ONZWV4B-7ULTJX6-C3SJWWY-73TA4R5-XR4QDTR-XE6FG5Q-HZBGMZW-3GM7RAN";
            };
          };

          folders = {
            "Pictures" = {
              path = "${config.syncthing.dataDir}/Pictures";
              devices = [
                "titan"
                "rhea"
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
                "rhea"
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
                "rhea"
              ];
              type = "sendreceive";
              fsWatcherEnabled = true;
              fsWatcherDelayS = 1;
              rescanIntervalS = 300;
            };
            "Videos" = {
              path = "${config.syncthing.dataDir}/Videos";
              devices = [
                "titan"
                "rhea"
              ];
              ignorePatterns = ["Screencasts"];
              type =
                if hostName == "titan"
                then "sendonly"
                else "receiveonly";
            };
          };
        };
      };
    };
  };
}
