{
  lib,
  config,
  ...
}: {
  options.immich.enable = lib.mkEnableOption "Enable immich";
  config = lib.mkIf config.immich.enable {
    services.immich = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = "/srv/storage/immich";
    };
  };
}
