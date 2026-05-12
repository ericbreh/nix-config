{inputs, ...}: {
  flake.modules.nixos.dev = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.dev];
  };

  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      cursor-cli
      gemini-cli
      gh
      uv
      clang
    ];
    programs.opencode = {
      enable = true;
      settings = {
        plugin = ["opencode-gemini-auth@latest"];
      };
    };
    home.sessionVariables.OPENCODE_EXPERIMENTAL_PLAN_MODE = "true";
    programs.git = {ignores = [".opencode/" ".cursor/"];};
  };
}
