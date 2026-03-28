{inputs, ...}: {
  flake.modules.nixos.silver = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      base
      immich
      jellyfin
      keyd
      nh
      openssh
      restic
      samba
      smart
      syncthing
      webdav
      core
      git
      lazygit
      nvim
      tmux
      zsh
    ];

    networking.hostName = "silver";

    users.users.ericbreh = {
      isNormalUser = true;
      description = "Eric Chuang";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR ericchuang94@gmail.com"
      ];
    };

    home-manager.users."ericbreh" = {
      home.username = "ericbreh";
      home.homeDirectory = "/home/ericbreh";
      home.stateVersion = "25.05";
      home.packages = with pkgs; [
        iperf
      ];
      tmux.prefix = "b";
    };

    syncthing.dataDir = "/srv/storage/syncthing";
    time.timeZone = "America/Los_Angeles";
    security.sudo.extraRules = [
      {
        users = ["ericbreh"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    services.tailscale.enable = true;
  };
}
