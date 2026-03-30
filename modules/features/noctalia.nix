{inputs, ...}: {
  flake.modules.nixos.noctalia = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.noctalia];
  };

  flake.modules.homeManager.noctalia = {config, ...}: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
    };

    home.file = {
      ".config/noctalia/".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia";
    };
  };
}
