{lib, ...}: {
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };

  keymaps = [
    {
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "Write the current buffer";
    }
    {
      key = "<leader>q";
      action = "<cmd>q<CR>";
      options.desc = "Quit the current window";
    }

    {
      key = "<C-w>n";
      action = "<cmd>vnew<CR>";
      options = {
        noremap = true;
        silent = true;
        desc = "New vertical split";
      };
    }

    {
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlights";
    }

    {
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }

    {
      mode = ["t"];
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
    {
      key = "<leader>e";
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
      options.desc = "Open Diagnostic Error list";
    }
    {
      key = "<leader>ke";
      action = lib.nixvim.mkRaw ''
        function()
          local diagnostics_signs_on =
            vim.g.have_nerd_font
            and {
              text = {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
                [vim.diagnostic.severity.INFO] = "󰋽 ",
                [vim.diagnostic.severity.HINT] = "󰌶 ",
              },
            }
            or {}

          local diagnostics_virtual_text_on = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          }

          local current_signs = vim.diagnostic.config().signs
          if current_signs and current_signs ~= false then
            vim.diagnostic.config { virtual_text = false, signs = false }
            vim.notify("Disabled ui diagnostic errors")
          else
            vim.diagnostic.config {
              virtual_text = diagnostics_virtual_text_on,
              signs = diagnostics_signs_on,
            }
            vim.notify("Enabled ui diagnostic errors")
          end
        end
      '';
      options.desc = "Toggle Errors";
    }
  ];
}
