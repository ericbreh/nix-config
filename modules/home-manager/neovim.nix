{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    alejandra
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dots/nvim/.config/nvim";
}
