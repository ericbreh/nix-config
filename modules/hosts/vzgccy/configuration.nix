{inputs, ...}: {
  flake.modules.homeManager.vzgccy = {
    imports = with inputs.self.modules.homeManager; [
      cli
      comma
      copilot
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
