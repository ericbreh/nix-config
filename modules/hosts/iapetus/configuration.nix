{inputs, ...}: {
  flake.modules.homeManager.iapetus = {
    imports = with inputs.self.modules.homeManager; [
      cli
      comma
      lazygit
      nh
      nixvim
      tmux
      zsh
    ];

    nixpkgs.config.allowUnfree = true;

    home.username = "vzgccy";
    home.homeDirectory = "/home/vzgccy";
    home.stateVersion = "25.05";

    programs.home-manager.enable = true;
    targets.genericLinux.enable = true;
  };
}
