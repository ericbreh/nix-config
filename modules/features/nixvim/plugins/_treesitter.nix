{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      c
      cpp
      diff
      html
      lua
      luadoc
      markdown
      markdown_inline
      query
      vim
      vimdoc
      dart
      rust
      python
      latex
    ];
  };
}
