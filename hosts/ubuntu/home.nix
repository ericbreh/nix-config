{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./../../modules/home-manager
    ../../modules/home-manager/core.nix
    ../../modules/home-manager/git.nix
    # ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh
    ../../modules/home-manager/nvim.nix
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  nixpkgs.config.allowUnfree = true;
  home.file.".terminfo/x/xterm-kitty".source = "${pkgs.kitty}/share/terminfo/x/xterm-kitty";

  programs.home-manager.enable = true;
}
