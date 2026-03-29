{inputs, ...}: {
  flake.modules.nixos.titan = {
    pkgs,
    config,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      base
      cli
      comma
      core
      direnv
      git
      greetd
      gui
      keyd
      kitty
      latex
      lazygit
      nh
      niri
      noctalia
      nvim
      podman
      steam
      syncthing
      theme
      tmux
      zsh
      zen-browser
    ];

    nix.settings = {
      extra-substituters = [
        "https://eko-network.cachix.org"
      ];
      extra-trusted-public-keys = [
        "eko-network.cachix.org-1:1xHfovoNlydsTCzXxr5AstUoJUmGR/tRq0PQSCyPab8="
      ];
    };

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

    services.automatic-timezoned.enable = true;
    services.geoclue2.enable = true;
    services.fprintd.enable = false;
    services.power-profiles-daemon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.printing.enable = true;
    services.tailscale.enable = true;
    services.thermald.enable = true;
  };
}
