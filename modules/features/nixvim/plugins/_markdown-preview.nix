{
  lib,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [
    pandoc
  ];
  plugins.markdown-preview.enable = true;

  keymaps = [
    {
      key = "<leader>km";
      action = "<cmd>MarkdownPreviewToggle<CR>";
      options.desc = "Toggle Markdown Preview";
    }
    {
      key = "<leader>kp";
      action = lib.nixvim.mkRaw ''
        function()
          local current_file = vim.fn.expand '%'
          local pdf_file = vim.fn.expand '%:r' .. '.pdf'
          local command = '!pandoc ' .. current_file .. ' -o ' .. pdf_file .. ' && xdg-open ' .. pdf_file
          vim.cmd(command)
        end
      '';
      options.desc = "Convert to PDF using Pandoc";
    }
  ];
}
