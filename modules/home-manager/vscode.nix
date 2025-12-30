{
  lib,
  config,
  ...
}: {
  options.home-manager.vscode.enable = lib.mkEnableOption "Enable vscode";
  config = lib.mkIf config.home-manager.vscode.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
