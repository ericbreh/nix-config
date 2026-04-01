{
  plugins.render-markdown = {
    enable = true;
    settings = {
      enabled = true;
      sign.enabled = false;
      heading = {
        backgrounds = [];
        position = "inline";
      };
      code = {
        width = "block";
        left_pad = 2;
        right_pad = 2;
      };
    };
  };

  keymaps = [
    {
      key = "<leader>kr";
      action = "<cmd>RenderMarkdown toggle<CR>";
      options.desc = "Toggle Render Markdown";
    }
  ];
}
