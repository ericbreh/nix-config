{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.niri.enable = lib.mkEnableOption "Enable niri";
  config = lib.mkIf config.niri.enable {
    services.swayidle = let
      lockScript = pkgs.writeShellScript "lock-screen" ''
        ${config.home.profileDirectory}/bin/noctalia-shell ipc call lockScreen lock
      '';
      suspendScript = pkgs.writeShellScript "suspend" ''
        systemctl suspend
      '';
    in {
      enable = true;
      systemdTarget = "graphical-session.target";
      timeouts = [
        {
          timeout = 300;
          command = "${lockScript}";
        }
        {
          timeout = 600;
          command = "${suspendScript}";
        }
      ];
      events = {
        before-sleep = "${lockScript}";
        lock = "${lockScript}";
      };
    };

    home.file = {
      ".config/niri".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/niri";
    };

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;

      settings = {
        bar.widgets = {
          left = [
            {
              id = "Workspace";
              labelMode = "none";
              hideUnoccupied = true;
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "ddd MMM d - h:mm AP";
            }
          ];
          right = [
            {id = "Tray";}
            {
              id = "SystemMonitor";
              compactMode = false;
              showCpuUsage = true;
              showCpuTemp = true;
              showMemoryUsage = true;
              useMonospaceFont = true;
              showMemoryAsPercent = true;
            }
            {id = "NotificationHistory";}
            {
              id = "Volume";
            }
            {
              id = "Battery";
              displayMode = "alwaysShow";
            }
            {id = "ControlCenter";}
          ];
        };
        ui = {
          fontDefault = "MesloLGS Nerd Font Propo";
          fontFixed = "MesloLGS Nerd Font Mono";
          tooltipsEnabled = false;
        };
        wallpaper = {
          directory = "/home/ericbreh/Pictures/Wallpapers";
          overviewEnabled = true;
        };
        appLauncher = {
          enableClipboardHistory = true;
          enableSettingsSearch = true;
        };
        controlCenter.cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        location = {
          name = "Berkeley";
          use12hourFormat = true;
        };
        general = {
          compactLockScreen = true;
          showSessionButtonsOnLockScreen = false;
        };
        dock.enabled = false;
        osd.location = "bottom";
        brightness.enableDdcSupport = true;
        colorSchemes.useWallpaperColors = true;
      };
    };
  };
}
