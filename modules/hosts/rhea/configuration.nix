{inputs, ...}: {
  flake.modules.nixos.rhea = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      # Common
      cli
      comma
      git
      keyd
      lazygit
      nh
      nixvim
      tmux
      zsh

      # Server
      openssh
      server-power
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

      fileSystems."/srv/storage" = {
        device = "/dev/disk/by-uuid/4e109b69-b58d-4e40-9f68-9da700e19211";
        fsType = "ext4";
        options = ["noatime"];
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
