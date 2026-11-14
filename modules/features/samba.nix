{...}: {
  flake.modules.nixos.samba = {config, ...}: {
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [139 445];

    services.samba = {
      enable = true;
      openFirewall = false;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = config.networking.hostName;
          "netbios name" = config.networking.hostName;
          "security" = "user";
          "hosts allow" = "100.64.0.0/10 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "vfs objects" = "catia fruit streams_xattr";
        };
        "syncthing" = {
          "path" = "/srv/storage/syncthing";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0640";
          "directory mask" = "0750";
          "valid users" = config.mainUser;
          "force user" = config.mainUser;
          "force group" = "users";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/storage/syncthing 0750 ${config.mainUser} users - -"
    ];
  };
}
