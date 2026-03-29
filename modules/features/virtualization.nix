{inputs, ...}: {
  flake.modules.nixos.virtualization = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.virtualization];
  };

  flake.modules.homeManager.virtualization = {pkgs, ...}: {
    home.packages = with pkgs; [
      distrobox
      quickemu
    ];
  };
}
