{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-ld.enable = lib.mkEnableOption "Enable nix-ld";
  config = lib.mkIf config.nix-ld.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
      ];
    };
  };
}
