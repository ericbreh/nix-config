{
  lib,
  config,
  ...
}: {
  options.latex.enable = lib.mkEnableOption "Enable latex";
  config = lib.mkIf config.latex.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-full;
      };
    };
    programs.pandoc = {
      enable = true;
    };
  };
}
