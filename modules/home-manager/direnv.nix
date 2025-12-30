{
  lib,
  config,
  ...
}: {
  options.home-manager.direnv.enable = lib.mkEnableOption "Enable direnv";
  config = lib.mkIf config.home-manager.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
