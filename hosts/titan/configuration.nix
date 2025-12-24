{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub = {
  #   enable = true;
  #   efiSupport = true;
  #   device = "nodev";
  #   useOSProber = true;
  # };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "titan";

  zramSwap.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  services.automatic-timezoned.enable = true;
  services.geoclue2.enable = true;

  # Select internationalisation properties.
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

  # # Enable the X11 windowing system.
  # services.xserver.enable = true;
  #
  # services.desktopManager.gnome.enable = true;
  # services.displayManager.gdm.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    i2c = {
      enable = true;
    };
  };
  services.fprintd.enable = false;
  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.ericbreh = {
    isNormalUser = true;
    description = "Eric Chuang";
    extraGroups = ["networkmanager" "wheel" "i2c"];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      "ericbreh" = import ./home.nix;
    };
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config = {
    permittedInsecurePackages = [
      "beekeeper-studio-5.3.4"
    ];
  };

  system.stateVersion = "25.05";
}
