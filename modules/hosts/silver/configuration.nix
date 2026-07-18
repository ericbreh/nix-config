{inputs, ...}: {
  flake.modules.nixos.silver = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      agenix
      cli
      git
      keyd
      lazygit
      nh
      nixvim
      openssh
      restic
      smart
      tmux
      zsh

      immich
      jellyfin
      navidrome
      samba
      syncthing
      webdav
    ];

    options.mainUser = lib.mkOption {
      type = lib.types.str;
      default = "ericbreh";
    };

    config = {
      nix.settings = {
        experimental-features = ["nix-command" "flakes"];
        extra-substituters = [
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      nix.extraOptions = "warn-dirty = false";
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.05";

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

      networking.networkmanager.enable = true;
      systemd.services.NetworkManager-wait-online.enable = false;
      zramSwap.enable = true;
      time.timeZone = "America/Los_Angeles";
      i18n.defaultLocale = "en_US.UTF-8";
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

      boot = {
        loader = {
          systemd-boot.enable = true;
          timeout = 1;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      security.sudo.extraRules = [
        {
          users = [config.mainUser];
          commands = [
            {
              command = "ALL";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];

      syncthing.dataDir = "/srv/storage/syncthing";
      services.tailscale.enable = true;
      programs.zsh.enable = true;
    };
  };
}
