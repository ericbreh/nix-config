{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wlogout
    wofi
    swaynotificationcenter
    hyprlock
    libnotify
    grim
    slurp
    wf-recorder
    brightnessctl
    bluetuith
    networkmanagerapplet

    phinger-cursors

    seahorse
    nautilus
    loupe
    papers
    showtime
    gnome-disk-utility
    baobab
  ];

  services.polkit-gnome.enable = true;
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };
  };
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;
  services.hyprsunset.enable = true;
  services.swayosd.enable = true;
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
  services.network-manager-applet.enable = true;
  services.playerctld.enable = true;

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
