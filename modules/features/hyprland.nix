{inputs, ...}: {
  flake.modules.nixos.hyprland = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.hyprland];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.gnome.gnome-keyring.enable = true;
  };

  flake.modules.homeManager.hyprland = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      hyprlock
      hyprsunset

      wofi
      wlogout

      grim
      slurp
      wf-recorder

      brightnessctl
      ddcutil
      bluetuith
      libnotify
      networkmanagerapplet
    ];

    services.polkit-gnome.enable = true;
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
    services.hyprpaper.enable = true;
    services.hypridle.enable = true;
    services.mako.enable = true;
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
      ".config/mako".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprland/mako";
    };
  };
}
