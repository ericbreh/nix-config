{pkgs, ...}: {
  home.packages = with pkgs; [
    unzip
    zip
    wget
    curl
    uv
    tree
    ncdu
    fastfetch
    btop
    ripgrep
    lazygit
    fd
    clang
    gnupg
  ];
}
