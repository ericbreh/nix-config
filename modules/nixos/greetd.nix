{
  lib,
  config,
  pkgs,
  ...
}: {
  options.greetd.enable = lib.mkEnableOption "Enable greetd";
  config = lib.mkIf config.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet -r";
        };
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
