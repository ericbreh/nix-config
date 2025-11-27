{pkgs, ...}: {
  imports = [
    ./../../modules/home-manager
  ];

  home.username = "ericbreh";
  home.homeDirectory = "/home/ericbreh";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    qbittorrent
    spotify
    signal-desktop
    gemini-cli
    bitwarden-desktop
    rustdesk-flutter
  ];

  programs.home-manager.enable = true;
}
