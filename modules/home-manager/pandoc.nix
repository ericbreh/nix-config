{
  lib,
  config,
  ...
}: {
  options.home-manager.pandoc.enable = lib.mkEnableOption "Enable pandoc";
  config = lib.mkIf config.home-manager.pandoc.enable {
    programs.pandoc = {
      enable = true;
    };
  };
}
