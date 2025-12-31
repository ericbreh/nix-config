{pkgs, ...}: {
  imports = [
    ./../../modules/home-manager
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    spotify
    bitwarden-desktop
    qbittorrent
    protonvpn-gui
    signal-desktop
    gemini-cli
    rustdesk-flutter
    handbrake
    losslesscut-bin
    beekeeper-studio
    nodejs_24
    zoom-us
    discord
    rnote
    inkscape
  ];

  home-manager.core.enable = true;
  home-manager.direnv.enable = true;
  home-manager.distrobox.enable = true;
  home-manager.firefox.enable = true;
  home-manager.git.enable = true;
  home-manager.gnome.enable = false;
  home-manager.hyprland.enable = true;
  home-manager.kitty.enable = true;
  home-manager.lazygit.enable = true;
  home-manager.nvim.enable = true;
  home-manager.pandoc.enable = true;
  home-manager.texlive.enable = true;
  home-manager.theme.enable = true;
  home-manager.tmux.enable = true;
  home-manager.vscode.enable = true;
  home-manager.zsh.enable = true;

  programs.home-manager.enable = true;
}
