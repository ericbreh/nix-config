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
          "hosts allow" = "100.64.0.0/10 fd7a:115c:a1e0::/48 127.0.0.1 ::1 localhost";
          "hosts deny" = "ALL";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "vfs objects" = "catia fruit streams_xattr";
        };
        "syncthing" = {
          "path" = config.syncthing.dataDir;
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
      "d ${config.syncthing.dataDir} 0750 ${config.mainUser} users - -"
    ];
  };
}
