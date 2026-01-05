{
  lib,
  config,
  pkgs,
  ...
}: {
  options.home-manager.nvim.enable = lib.mkEnableOption "Enable nvim";
  config = lib.mkIf config.home-manager.nvim.enable {
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

      ty
      ruff

      markdownlint-cli

      texlab

      jq

      gopls
      gofumpt
    ];

    home.file.".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
  };
}
