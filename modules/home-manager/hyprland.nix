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
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland/hypr";
    ".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland/waybar";
    ".config/wlogout".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland/wlogout";
    ".config/wofi".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland/wofi";
    ".config/swaync".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland/swaync";
  };
}
