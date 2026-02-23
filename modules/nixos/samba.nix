{
  lib,
  config,
  ...
}: {
  options.samba = {
    enable = lib.mkEnableOption "Enable samba";
  };

  config = lib.mkIf config.samba.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = config.networking.hostName;
          "netbios name" = config.networking.hostName;
          "security" = "user";
          "hosts allow" = "192.168.0.0/16 127.0.0.1 100.64.0.0/10 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "syncthing" = {
          "path" = "/srv/storage/syncthing";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "valid users" = "ericbreh";
          "force user" = "ericbreh";
          "force group" = "users";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/storage/syncthing 0775 ericbreh users - -"
    ];
  };
}
