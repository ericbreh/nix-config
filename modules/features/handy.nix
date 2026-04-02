{inputs, ...}: {
  flake.modules.nixos.handy = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.handy];
  };

  flake.modules.homeManager.handy = {pkgs, ...}: {
    home.packages = [
      inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.wtype
    ];
  };
}
