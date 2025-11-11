{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tmux
    wl-clipboard
    lazygit
  ];
  home.file.".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dots/tmux/.config/tmux";
}
