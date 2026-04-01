{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    no-neck-pain-nvim
  ];

  extraConfigLua = ''
    require('no-neck-pain').setup {
      width = 130,
    }
  '';

  keymaps = [
    {
      key = "<leader>kn";
      action = "<cmd>NoNeckPain<CR>";
      options.desc = "Toggle NoNeckPain";
    }
  ];
}
