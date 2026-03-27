{inputs, ...}: {
  flake.modules.nixos.eko-messenger-client = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.eko-messenger-client];
  };

  flake.modules.homeManager.eko-messenger-client = {pkgs, ...}: {
    home.packages = [
      inputs.eko-messenger-client.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
