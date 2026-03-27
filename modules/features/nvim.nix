{inputs, ...}: {
  flake.modules.nixos.nvim = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.nvim];
  };

  flake.modules.homeManager.nvim = {
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
      tree-sitter
      ghostscript

      clang-tools

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
      ltex-ls-plus

      gopls
      gofumpt

      jq

      sql-formatter
    ];

    programs.pandoc = {
      enable = true;
    };

    home.file.".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
  };
}
