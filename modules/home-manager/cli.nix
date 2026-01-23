{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cli.enable = lib.mkEnableOption "Enable CLI packages";
  config = lib.mkIf config.cli.enable {
    home.packages = with pkgs; [
      nerd-fonts.meslo-lg
      gemini-cli
      cursor-cli
      nodejs_24
      gh
      distrobox
    ];
    programs.opencode = {
      enable = true;
      settings = {
        plugin = ["opencode-gemini-auth@latest"];
      };
    };
  };
}
