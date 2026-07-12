{inputs, ...}: {
  flake.modules.nixos.titan = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      cli
      comma
      dev
      direnv
      eko
      foot
      git
      greetd
      gui
      handy
      keyd
      kitty
      kunifiedpush
      latex
      lazygit
      nh
      nix-ld
      niri
      nixvim
      podman
      steam
      syncthing
      theme
      tmux
      virtualization
      zsh
      zen-browser
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
          "https://eko-network.cachix.org"
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "eko-network.cachix.org-1:1xHfovoNlydsTCzXxr5AstUoJUmGR/tRq0PQSCyPab8="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
      nix.extraOptions = "warn-dirty = false";
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.05";

      networking.hostName = "titan";

      users.users.${config.mainUser} = {
        isNormalUser = true;
        description = "Eric Chuang";
        extraGroups = ["networkmanager" "wheel" "i2c" "dialout"];
        shell = pkgs.zsh;
      };

      home-manager.users.${config.mainUser} = {
        home.homeDirectory = "/home/${config.mainUser}";
        home.stateVersion = "25.05";
      };

      networking.networkmanager.enable = true;
      systemd.services.NetworkManager-wait-online.enable = false;
      zramSwap.enable = true;
      services.automatic-timezoned.enable = true;
      services.geoclue2.enable = true;
      i18n.defaultLocale = "en_US.UTF-8";
      services.gvfs.enable = true;
      services.udisks2.enable = true;
      services.printing.enable = true;
      services.fprintd.enable = false;
      services.power-profiles-daemon.enable = true;
      services.thermald.enable = true;
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        i2c.enable = true;
      };
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      boot = {
        loader = {
          systemd-boot.enable = true;
          timeout = 1;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      services.tailscale.enable = true;
      programs.zsh.enable = true;
    };
  };
}
