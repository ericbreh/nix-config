{
  lib,
  config,
  ...
}: {
  options.home-manager.nh.enable = lib.mkEnableOption "Enable nh";
  config = lib.mkIf config.home-manager.nh.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.home.homeDirectory}/nix-config";
    };
  };
}
