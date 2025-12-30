{
  lib,
  config,
  ...
}: {
  options.home-manager.firefox.enable = lib.mkEnableOption "Enable firefox";
  config = lib.mkIf config.home-manager.firefox.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
