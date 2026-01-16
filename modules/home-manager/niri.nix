{
  lib,
  config,
  pkgs,
  ...
}: {
  options.niri.enable = lib.mkEnableOption "Enable niri";
  config = lib.mkIf config.niri.enable {
    home.packages = with pkgs; [
      seahorse
      nautilus
      loupe
      showtime
      decibels
      papers
      gnome-disk-utility
      baobab
      snapshot
    ];

    services.cliphist = {
      enable = true;
      allowImages = true;
    };

    home.file = {
      ".config/niri".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/niri";
    };
  };
}
