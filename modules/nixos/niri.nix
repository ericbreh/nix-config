{
  pkgs,
  lib,
  config,
  ...
}: {
  options.niri.enable = lib.mkEnableOption "Enable niri";
  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    services.upower.enable = true;
    programs.dsearch.enable = true;
    programs.dms-shell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableClipboard = true; # Clipboard history manager
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
    };
  };
}
