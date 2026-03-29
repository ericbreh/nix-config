{...}: {
  flake.modules.nixos.base = {
    pkgs,
    lib,
    ...
  }: {
    options.mainUser = lib.mkOption {
      type = lib.types.str;
      default = "ericbreh";
    };

    config = {
      nix.settings.experimental-features = ["nix-command" "flakes"];
      nix.extraOptions = "warn-dirty = false";
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.05";

      boot = {
        loader = {
          systemd-boot.enable = true;
          timeout = 1;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      networking.networkmanager.enable = true;
      systemd.services.NetworkManager-wait-online.enable = false;

      zramSwap.enable = true;

      i18n.defaultLocale = "en_US.UTF-8";

      programs.zsh.enable = true;
    };
  };
}
