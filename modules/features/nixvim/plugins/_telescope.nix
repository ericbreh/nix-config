{
  lib,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [
    ripgrep
    fd
  ];

  plugins.web-devicons.enable = true;

  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>sh";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "Search Help";
    }
    {
      mode = "n";
      key = "<leader>sk";
      action = "<cmd>Telescope keymaps<CR>";
      options.desc = "Search Keymaps";
    }
    {
      mode = "n";
      key = "<leader>st";
      action = "<cmd>Telescope builtin<CR>";
      options.desc = "Search Telescope";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Search by Grep";
    }
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>Telescope diagnostics<CR>";
      options.desc = "Search Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>Telescope resume<CR>";
      options.desc = "Search Resume";
    }
    {
      mode = "n";
      key = "<leader>s.";
      action = "<cmd>Telescope oldfiles<CR>";
      options.desc = "Search Recent Files";
    }
    {
      mode = "n";
      key = "<leader>sc";
      action = "<cmd>Telescope commands<CR>";
      options.desc = "Search Commands";
    }
    {
      mode = "n";
      key = "<leader>sf";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "Search Open Files";
    }
    {
      mode = ["n" "v"];
      key = "<leader>sw";
      action = "<cmd>Telescope grep_string<CR>";
      options.desc = "Search Current Word";
    }
    {
      mode = "n";
      key = "<leader><leader>";
      action = lib.nixvim.mkRaw ''
        function()
          require("telescope.builtin").find_files { hidden = true, no_ignore = true }
        end
      '';
      options.desc = "Search Files";
    }
    {
      mode = "n";
      key = "<leader>/";
      action = lib.nixvim.mkRaw ''
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end
      '';
      options.desc = "Fuzzily search in current buffer";
    }
    {
      mode = "n";
      key = "<leader>s/";
      action = lib.nixvim.mkRaw ''
        function()
          require("telescope.builtin").live_grep {
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          }
        end
      '';
      options.desc = "Search in Open Files";
    }
    {
      mode = "n";
      key = "<leader>sn";
      action = lib.nixvim.mkRaw ''
        function()
          require("telescope.builtin").find_files { cwd = vim.fn.stdpath 'config' }
        end
      '';
      options.desc = "Search Neovim Files";
    }
  ];
}
