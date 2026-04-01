{lib, ...}: {
  plugins.snacks = {
    enable = true;
    settings = {
      dashboard = {
        enabled = true;
        preset = {
          header = lib.nixvim.mkRaw ''
            table.concat({
              [[                                                                       ]],
              [[                                                                     ]],
              [[       ████ ██████           █████      ██                     ]],
              [[      ███████████             █████                             ]],
              [[      █████████ ███████████████████ ███   ███████████   ]],
              [[     █████████  ███    █████████████ █████ ██████████████   ]],
              [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
              [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
              [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
              [[                                                                       ]],
            }, '\n')
          '';
        };
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
      scratch = {
        enabled = true;
        ft = "markdown";
      };
      image.enabled = true;
      git.enabled = true;
    };
  };

  keymaps = [
    {
      key = "<leader>.";
      action = lib.nixvim.mkRaw "function() Snacks.scratch() end";
      options.desc = "Toggle Scratch Buffer";
    }
    {
      key = "<leader>ss";
      action = lib.nixvim.mkRaw "function() Snacks.scratch.select() end";
      options.desc = "Search Scratch Buffer";
    }
    {
      key = "<leader>gg";
      action = lib.nixvim.mkRaw "function() Snacks.lazygit() end";
      options.desc = "Lazygit";
    }
    {
      key = "<leader>gb";
      action = lib.nixvim.mkRaw "function() Snacks.git.blame_line() end";
      options.desc = "Git Blame";
    }
  ];
}
