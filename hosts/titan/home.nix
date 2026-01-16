{pkgs, ...}: {
  imports = [
    ./../../modules/home-manager
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    gemini-cli
    opencode
    nodejs_24
    gh
    distrobox

    firefox
    spotify
    bitwarden-desktop
    qbittorrent
    protonvpn-gui
    signal-desktop
    zoom-us
    discord
    vscode
    wasistlos
    jellyfin-media-player

    rustdesk-flutter
    beekeeper-studio

    rnote
    inkscape
  ];

  core.enable = true;
  direnv.enable = true;
  git.enable = true;
  hyprland.enable = false;
  kitty.enable = true;
  lazygit.enable = true;
  niri.enable = true;
  nvim.enable = true;
  latex.enable = true;
  theme.enable = true;
  tmux.enable = true;
  zsh.enable = true;

  programs.home-manager.enable = true;
}
