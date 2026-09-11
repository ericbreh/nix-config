{inputs, ...}: {
  flake.modules.nixos.copilot = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.copilot];
  };

  flake.modules.homeManager.copilot = {pkgs, ...}: {
    home.packages = with pkgs; [
      github-copilot-cli
    ];
  };
}
