{
  pkgs,
  inputs,
  ...
}: {
  # nix
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    extra-substituters = [
      "https://eko-network.cachix.org"
    ];
    extra-trusted-public-keys = [
      "eko-network.cachix.org-1:1xHfovoNlydsTCzXxr5AstUoJUmGR/tRq0PQSCyPab8="
    ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
  ];

  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
  zramSwap.enable = true;

  # networking
  networking.hostName = "titan";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # i18n
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # time
  services.automatic-timezoned.enable = true;
  services.geoclue2.enable = true;

  # sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # hardware
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

  # services
  services.fprintd.enable = false;
  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.printing.enable = true;
  services.tailscale.enable = true;
  services.thermald.enable = true;

  users.users.ericbreh = {
    isNormalUser = true;
    description = "Eric Chuang";
    extraGroups = ["networkmanager" "wheel" "i2c" "dialout"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      "ericbreh" = import ./home.nix;
    };
  };

  gnome.enable = false;
  greetd.enable = true;
  hyprland.enable = false;
  keyd.enable = true;
  nh.enable = true;
  niri.enable = true;
  nix-ld.enable = false;
  podman.enable = true;
  syncthing.enable = true;
  syncthing.type = "sendonly";
  steam.enable = true;
}
