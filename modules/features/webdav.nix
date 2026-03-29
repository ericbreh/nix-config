{...}: {
  flake.modules.nixos.webdav = {config, ...}: {
    services.webdav = {
      enable = true;
      user = config.mainUser;
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
