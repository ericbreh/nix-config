{
  lib,
  config,
  pkgs,
  ...
}: {
  options.gui.enable = lib.mkEnableOption "Enable GUI packages";
  config = lib.mkIf config.gui.enable {
    home.packages = with pkgs; [
      firefox
      ungoogled-chromium

      discord
      signal-desktop
      teams-for-linux
      wasistlos
      zoom-us

      spotify
      jellyfin-media-player

      vscode
      rnote
      inkscape

      bitwarden-desktop
      qbittorrent
      protonvpn-gui
      rustdesk-flutter
      prismlauncher

      nautilus
      seahorse
      loupe
      baobab
      gnome-disk-utility
      papers
      snapshot
      showtime
      decibels
      gnome-control-center
    ];
  };
}
