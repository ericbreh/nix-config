{inputs, ...}: {
  flake.modules.nixos.gui = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.gui];
  };

  flake.modules.homeManager.gui = {pkgs, ...}: {
    home.packages = with pkgs; [
      firefox
      ungoogled-chromium

      discord
      signal-desktop
      altus
      zoom-us
      teams-for-linux

      jellyfin-media-player
      feishin

      vscode
      rnote
      inkscape
      obsidian

      qbittorrent
      proton-vpn
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
