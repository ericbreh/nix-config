{
  lib,
  config,
  ...
}: {
  options.niri.enable = lib.mkEnableOption "Enable niri";
  config = lib.mkIf config.niri.enable {
    home.file = {
      ".config/niri".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/niri";
    };
  };
}
