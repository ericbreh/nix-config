{...}: {
  autoCmd = [
    {
      event = "TextYankPost";
      callback = {
        __raw = "function() vim.hl.on_yank() end";
      };
    }
  ];
}
