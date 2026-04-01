{lib, ...}: {
  plugins.mini = {
    enable = true;
    modules = {
      ai = {
        n_lines = 500;
      };
      surround = {};
      statusline = {
        use_icons = true;
      };
      diff = {};
    };
  };

  extraConfigLua = ''
    require('mini.statusline').section_location = function()
      return '%2l:%-2v'
    end
  '';

  keymaps = [
    {
      key = "<leader>gd";
      action = lib.nixvim.mkRaw "require('mini.diff').toggle_overlay";
      options.desc = "Toggle Git Diff Overlay";
    }
  ];
}
