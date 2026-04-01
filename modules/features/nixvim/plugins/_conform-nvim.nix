{
  lib,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [
    stylua
    shfmt
    clang-tools
    alejandra
    rustfmt
    ruff
    markdownlint-cli
    jq
    gofumpt
    sql-formatter
  ];

  plugins.conform-nvim = {
    enable = true;

    settings = {
      notify_on_error = false;

      format_on_save = lib.nixvim.mkRaw ''
        function(bufnr)
          if vim.b[bufnr].disable_autoformat then
            return
          end
          local disable_filetypes = {}
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          end
          return {
            timeout_ms = 1000,
            lsp_format = "fallback",
          }
        end
      '';

      formatters_by_ft = {
        lua = ["stylua"];
        bash = ["shfmt"];
        c = ["clang_format"];
        cpp = ["clang_format"];
        nix = ["alejandra"];
        rust = ["rustfmt"];
        python = ["ruff"];
        markdown = ["markdownlint"];
        tex = ["latexindent"];
        json = ["jq"];
        go = ["gofumpt"];
        sql = ["sql_formatter"];
        dart = ["dart_format"];
      };
    };
  };

  keymaps = [
    {
      key = "<leader>f";
      action = lib.nixvim.mkRaw ''
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end
      '';
      options.desc = "Format buffer";
    }
    {
      key = "<leader>kf";
      action = lib.nixvim.mkRaw ''
        function()
          if vim.b.disable_autoformat then
            vim.b.disable_autoformat = false
            vim.notify("Enabled autoformat")
          else
            vim.b.disable_autoformat = true
            vim.notify("Disabled autoformat")
          end
        end
      '';
      options.desc = "Toggle auto Format on save";
    }
  ];
}
