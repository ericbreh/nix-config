{
  lib,
  config,
  pkgs,
  ...
}: {
  options.home-manager.theme.enable = lib.mkEnableOption "Enable theme";
  config = lib.mkIf config.home-manager.theme.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };

    home.pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
    };
  };
}
