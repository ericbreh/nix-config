{inputs, ...}: {
  flake.modules.nixos.latex = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.latex];
  };

  flake.modules.homeManager.latex = {pkgs, ...}: {
    home.packages = with pkgs; [
      texliveFull
    ];
  };
}
