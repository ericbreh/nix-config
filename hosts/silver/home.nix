{pkgs, ...}: {
  imports = [
    ./../../modules/home-manager
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    iperf
  ];

  core.enable = true;
  direnv.enable = true;
  git.enable = true;
  lazygit.enable = true;
  nvim.enable = true;
  tmux.enable = true;
  tmux.prefix = "b";
  zsh.enable = true;

  programs.home-manager.enable = true;
}
