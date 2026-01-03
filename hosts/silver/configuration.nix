{
  pkgs,
  inputs,
  ...
}: {
  # nix
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  zramSwap.enable = true;

  # networking
  networking.hostName = "silver";
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
  time.timeZone = "America/Los_Angeles";

  # disks
  fileSystems = {
    "/srv/storage" = {
      device = "/dev/disk/by-uuid/daf86907-e811-4bd1-9baf-fa44f2a83203";
      fsType = "ext4";
    };
  };

  # services
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
  services.tailscale.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT0 = 55;
      START_CHARGE_THRESH_BAT0 = 45;
    };
  };

  users.users.ericbreh = {
    isNormalUser = true;
    description = "Eric Chuang";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR ericchuang94@gmail.com"
    ];
  };
  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      "ericbreh" = import ./home.nix;
    };
  };

  immich.enable = true;
  keyd.enable = true;
  nh.enable = true;
  openssh.enable = true;
}
