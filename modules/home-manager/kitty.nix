{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.kitty];
  home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dots/kitty/.config/kitty";
}
