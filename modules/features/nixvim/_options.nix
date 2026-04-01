{lib, ...}: {
  opts = {
    number = true;
    relativenumber = true;
    mouse = "a";
    showmode = false;

    # Sync clipboard between OS and Neovim.
    clipboard = "unnamedplus";

    breakindent = true;
    undofile = true;

    ignorecase = true;
    smartcase = true;

    signcolumn = "yes";
    updatetime = 250;
    timeoutlen = 300;

    splitright = true;
    splitbelow = true;

    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };

    inccommand = "split";
    cursorline = true;
    scrolloff = 10;

    confirm = true;
    swapfile = false;

    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 4;
    expandtab = true;
  };

  diagnostic.settings = {
    update_in_insert = false;
    severity_sort = true;
    float = {
      border = "rounded";
      source = "if_many";
    };
    underline = {
      severity = {
        min = lib.nixvim.mkRaw "vim.diagnostic.severity.WARN";
      };
    };
    signs = {
      text = lib.nixvim.mkRaw ''
        {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        }
      '';
    };
    virtual_text = {
      source = "if_many";
      spacing = 2;
      format = lib.nixvim.mkRaw ''
        function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end
      '';
    };
    jump = {
      float = true;
    };
  };
}
