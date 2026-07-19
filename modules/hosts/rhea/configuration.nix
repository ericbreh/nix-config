{inputs, ...}: {
  flake.modules.nixos.rhea = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      cli
      comma
      git
      keyd
      lazygit
      nh
      nixvim
      openssh
      tmux
      zsh
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

      networking.hostName = "rhea";

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
        tmux.prefix = "b";
      };

      networking.networkmanager.enable = true;
      systemd.services.NetworkManager-wait-online.enable = false;
      zramSwap.enable = true;
      time.timeZone = "America/Detroit";
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

      boot = {
        loader = {
          systemd-boot.enable = true;
          timeout = 1;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      programs.zsh.enable = true;
    };
  };
}
