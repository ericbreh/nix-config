{...}: {
  imports = [
    ./../../modules/home-manager
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  cli.enable = true;
  core.enable = true;
  direnv.enable = true;
  eko-messenger-client.enable = true;
  git.enable = true;
  gui.enable = true;
  hyprland.enable = false;
  kitty.enable = true;
  latex.enable = true;
  lazygit.enable = true;
  niri.enable = true;
  nvim.enable = true;
  theme.enable = true;
  tmux.enable = true;
  zsh.enable = true;

  programs.home-manager.enable = true;
}
