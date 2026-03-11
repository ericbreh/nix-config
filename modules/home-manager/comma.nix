{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [inputs.nix-index-database.homeModules.default];
  options.comma.enable = lib.mkEnableOption "Enable comma";
  config = lib.mkIf config.comma.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
