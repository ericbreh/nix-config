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

      qbittorrent
      bitwarden-desktop
      proton-vpn
      prismlauncher

      seahorse
      gnome-disk-utility

      nautilus
      papers
      loupe
      snapshot
      showtime
      video-trimmer
      gnome-text-editor

      vscode
      obsidian

      rnote
      inkscape
      kdePackages.kdenlive
      pinta
    ];
  };
}
