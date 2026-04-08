{
  plugins.neo-tree = {
    enable = true;
    autoLoad = true;
    settings = {
      filesystem = {
        filtered_items = {
          visible = true;
        };
        window = {
          mappings = {
            "\\" = "close_window";
          };
        };
      };
    };
  };

  keymaps = [
    {
      key = "\\";
      action = "<cmd>Neotree reveal<CR>";
      options = {
        silent = true;
        desc = "NeoTree reveal";
      };
    }
  ];
}
