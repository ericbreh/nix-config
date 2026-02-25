{
  lib,
  config,
  ...
}: {
  options.webdav.enable = lib.mkEnableOption "Enable webdav";
  config = lib.mkIf config.webdav.enable {
    services.webdav = {
      enable = true;
      user = "ericbreh";
      group = "users";
      environmentFile = "/etc/webdav-secret";
      settings = {
        address = "0.0.0.0";
        port = 8080;
        directory = "/srv/storage/syncthing/notes";
        permissions = "CRUD";
        users = [
          {
            username = "{env}WEBDAV_USERNAME";
            password = "{env}WEBDAV_PASSWORD";
          }
        ];
      };
    };
  };
}
