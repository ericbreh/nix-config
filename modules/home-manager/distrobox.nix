{
  lib,
  config,
  ...
}: {
  options.home-manager.distrobox.enable = lib.mkEnableOption "Enable distrobox";
  config = lib.mkIf config.home-manager.distrobox.enable {
    programs.distrobox = {
      enable = true;
    };
  };
}
