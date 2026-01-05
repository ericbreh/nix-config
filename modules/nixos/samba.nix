{
  lib,
  config,
  ...
}: {
  options.samba = {
    enable = lib.mkEnableOption "Enable samba";

    username = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "samba username";
    };
  };

  config = lib.mkIf config.samba.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "silver";
          "netbios name" = "silver";
          "security" = "user";
          "hosts allow" = "192.168.0.0/16 127.0.0.1 100.64.0.0/10 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/srv/storage/share/public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nobody";
          "force group" = "nogroup";
        };
        "private" = {
          "path" = "/srv/storage/share/private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "valid users" = config.samba.username;
          "force user" = config.samba.username;
          "force group" = "users";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    systemd.tmpfiles.rules = [
      "d /srv/storage/share 0755 ${config.samba.username} users - -"
      "d /srv/storage/share/private 0775 ${config.samba.username} users - -"
      "d /srv/storage/share/public 0775 nobody nogroup - -"
    ];
  };
}
