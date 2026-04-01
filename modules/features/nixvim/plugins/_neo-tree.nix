{
  plugins.neo-tree = {
    enable = true;
    autoLoad = true;
    settings = {
      filesystem = {
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
