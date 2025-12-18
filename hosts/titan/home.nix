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

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
  };

  programs.home-manager.enable = true;
}
