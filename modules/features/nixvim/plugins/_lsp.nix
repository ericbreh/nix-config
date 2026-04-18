{
  lib,
  pkgs,
  ...
}: {
  plugins.fidget.enable = true;

  autoGroups = {
    "kickstart-lsp-attach" = {
      clear = true;
    };
  };

  plugins.lsp = {
    enable = true;
    inlayHints = false;

    servers = {
      lua_ls = {
        enable = true;
        settings = {
          Lua = {
            completion.callSnippet = "Replace";
            diagnostics = {
              globals = ["vim"];
              disable = ["missing-fields"];
            };
            workspace.checkThirdParty = false;
            telemetry.enable = false;
          };
        };
      };

      bashls.enable = true;
      clangd = {
        enable = true;
        cmd = [
          "clangd"
          "--query-driver=/nix/store/*-xtensa-esp-elf-esp-idf-*/bin/xtensa-esp32-elf-gcc"
        ];
      };
      nixd.enable = true;
      rust_analyzer.enable = true;
      rust_analyzer.installCargo = false;
      rust_analyzer.installRustc = false;
      ty = {
        enable = true;
        rootMarkers = [".git"];
      };
      gopls.enable = true;
      dartls.enable = true;
      texlab.enable = true;
      ltex_plus = {
        enable = true;
        package = pkgs.ltex-ls-plus;
      };
    };

    keymaps = {
      lspBuf = {
        "grn" = {
          action = "rename";
          desc = "Rename";
        };
        "gra" = {
          mode = ["n" "x"];
          action = "code_action";
          desc = "Goto Code Action";
        };
        "grD" = {
          action = "declaration";
          desc = "Goto Declaration";
        };
      };

      extra = [
        {
          mode = "n";
          key = "grr";
          action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references";
          options.desc = "Goto References";
        }
        {
          mode = "n";
          key = "gri";
          action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_implementations";
          options.desc = "Goto Implementation";
        }
        {
          mode = "n";
          key = "grd";
          action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
          options.desc = "Goto Definition";
        }
        {
          mode = "n";
          key = "gO";
          action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_document_symbols";
          options.desc = "Open Document Symbols";
        }
        {
          mode = "n";
          key = "gW";
          action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_dynamic_workspace_symbols";
          options.desc = "Open Workspace Symbols";
        }
        {
          mode = "n";
          key = "grt";
          action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_type_definitions";
          options.desc = "Goto Type Definition";
        }
      ];
    };

    onAttach = ''
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      local function client_supports_method(client, method, bufnr)
        if vim.fn.has 'nvim-0.11' == 1 then
          return client:supports_method(method, bufnr)
        else
          return client.supports_method(method, { bufnr = bufnr })
        end
      end

      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
        vim.keymap.set('n', '<leader>kh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'LSP: Toggle Inlay Hints' })
      end
    '';
  };
}
