{inputs, ...}: {
  flake.modules.nixos.cli = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.cli];
  };

  flake.modules.homeManager.cli = {pkgs, ...}: {
    home.packages = with pkgs; [
      cursor-cli
      gh
      distrobox
      quickemu
      uv
      clang
    ];
    programs.opencode = {
      enable = true;
      settings = {
        plugin = ["opencode-gemini-auth@latest"];
      };
    };
  };
}
