{pkgs, ...}: {
  home.packages = with pkgs; [
    unzip
    zip
    wget
    curl
    ripgrep
    fd
    wl-clipboard
    uv
    tree
    ncdu
    fastfetch
    btop
  ];
}
