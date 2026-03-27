{inputs, ...}: {
  flake.modules.nixos.direnv = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.direnv];
  };

  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
