{
  lib,
  config,
  ...
}: {
  options.niri.enable = lib.mkEnableOption "Enable niri";
  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;
  };
}
