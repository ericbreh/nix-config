{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    waybar
    wlogout
    wofi
    swaynotificationcenter
    swayosd
    hyprlock
    hyprpaper
    hypridle
    hyprsunset
    phinger-cursors
    cliphist
    libnotify
    grim
    slurp
    brightnessctl
  ];

  home.file = {
    ".config/hypr".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland";
    ".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/waybar";
    ".config/wlogout".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wlogout";
    ".config/wofi".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wofi";
    ".config/swaync".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/swaync";
  };
}
