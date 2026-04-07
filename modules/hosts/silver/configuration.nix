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
      nvim
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

    services.tailscale.enable = true;
  };
}
