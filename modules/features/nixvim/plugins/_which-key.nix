{
  plugins.which-key = {
    enable = true;

    settings = {
      delay = 0;
      icons.mappings = true;
      spec = [
        {
          __unkeyed-1 = "<leader>s";
          group = "Search";
          mode = ["n" "v"];
        }
        {
          __unkeyed-1 = "<leader>k";
          group = "Misc";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
          mode = ["n" "v"];
        }
        {
          __unkeyed-1 = "gr";
          group = "LSP Actions";
          mode = ["n"];
        }
      ];
    };
  };
}
