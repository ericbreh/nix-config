{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    clang

    lua-language-server
    stylua

    bash-language-server
    shfmt

    nixd
    alejandra

    rust-analyzer
    rustfmt

    basedpyright
    black

    markdownlint-cli

    texlab

    jq
  ];

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
