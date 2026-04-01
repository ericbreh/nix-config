{inputs, ...}: {
  flake.modules.nixos.nixvim = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.nixvim];
  };

  flake.modules.homeManager.nixvim = {
    imports = [
      inputs.nixvim.homeModules.default
    ];

    programs.nixvim = {
      enable = true;
      imports = [
        ./_options.nix
        ./_keymaps.nix
        ./_autocmds.nix
        ./plugins/_telescope.nix
        ./plugins/_treesitter.nix
        ./plugins/_lsp.nix
        ./plugins/_blink-cmp.nix
        ./plugins/_conform-nvim.nix
        ./plugins/_which-key.nix
        ./plugins/_vague.nix
        ./plugins/_guess-indent.nix
        ./plugins/_indent-blankline.nix
        ./plugins/_nvim-autopairs.nix
        ./plugins/_smear-cursor.nix
        ./plugins/_todo-comments.nix
        ./plugins/_neo-tree.nix
        ./plugins/_vimtex.nix
        ./plugins/_markdown-preview.nix
        ./plugins/_render-markdown.nix
        ./plugins/_flutter-tools.nix
        ./plugins/_no-neck-pain.nix
        ./plugins/_mini.nix
        ./plugins/_snacks.nix
      ];
    };
  };
}
