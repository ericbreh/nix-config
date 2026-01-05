{
  pkgs,
  lib,
  config,
  ...
}: {
  options.jellyfin.enable = lib.mkEnableOption "Enable jellyfin";
  config = lib.mkIf config.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
  };
}
