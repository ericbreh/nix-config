{
  lib,
  config,
  ...
}: {
  options.home-manager.texlive.enable = lib.mkEnableOption "Enable texlive";
  config = lib.mkIf config.home-manager.texlive.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-full;
      };
    };
  };
}
