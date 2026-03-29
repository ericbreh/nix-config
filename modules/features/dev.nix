{inputs, ...}: {
  flake.modules.nixos.dev = {
    imports = [inputs.self.modules.nixos.opencode];
    home-manager.sharedModules = [inputs.self.modules.homeManager.dev];
  };

  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      cursor-cli
      gh
      uv
      clang
    ];
  };
}
