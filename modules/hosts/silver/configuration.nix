{inputs, ...}: {
  flake.modules.nixos.silver = {
    pkgs,
    config,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      agenix
      base
      cli
      git
      immich
      jellyfin
      keyd
      lazygit
      nh
      nixvim
      openssh
      restic
      samba
      smart
      syncthing
      tmux
      webdav
      zsh
    ];

    nix.settings = {
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    networking.hostName = "silver";

    users.users.${config.mainUser} = {
      isNormalUser = true;
      description = "Eric Chuang";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR ericchuang94@gmail.com"
      ];
    };

    home-manager.users.${config.mainUser} = {
      home.homeDirectory = "/home/${config.mainUser}";
      home.stateVersion = "25.05";
      home.packages = with pkgs; [
        iperf
      ];
      tmux.prefix = "b";
    };

    syncthing.dataDir = "/srv/storage/syncthing";
    time.timeZone = "America/Los_Angeles";
    services.tailscale.enable = true;
    services.logind = {
      settings = {
        Login = {
          AllowSuspend = false;
          AllowHibernation = false;
          AllowHybridSleep = false;
          AllowSuspendThenHibernate = false;
          HandleLidSwitch = "ignore";
        };
      };
    };
    services.tlp = {
      enable = true;
      settings = {
        STOP_CHARGE_THRESH_BAT0 = 55;
        START_CHARGE_THRESH_BAT0 = 45;
      };
    };

    fileSystems."/srv/storage" = {
      device = "/dev/disk/by-uuid/daf86907-e811-4bd1-9baf-fa44f2a83203";
      fsType = "ext4";
      options = ["noatime"];
    };

    fileSystems."/srv/backup" = {
      device = "/dev/disk/by-uuid/ae6a911d-ccbf-48fc-a54f-2ba26a036269";
      fsType = "ext4";
      options = ["nofail" "noatime"];
    };
  };
}
