{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cli.enable = lib.mkEnableOption "Enable CLI packages";
  config = lib.mkIf config.cli.enable {
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
