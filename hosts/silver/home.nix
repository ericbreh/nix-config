{pkgs, ...}: {
  imports = [
    ./../../modules/home-manager
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  # home.packages = with pkgs; [
  # ];

  home-manager.core.enable = true;
  home-manager.direnv.enable = true;
  home-manager.git.enable = true;
  home-manager.lazygit.enable = true;
  home-manager.nh.enable = true;
  home-manager.nvim.enable = true;
  home-manager.tmux.enable = true;
  home-manager.zsh.enable = true;

  programs.home-manager.enable = true;
}
