{
  lib,
  config,
  pkgs,
  ...
}: {
  options.home-manager.core.enable = lib.mkEnableOption "Enable core";
  config = lib.mkIf config.home-manager.core.enable {
    home.packages = with pkgs; [
      unzip
      zip
      wget
      curl
      ripgrep
      fd
      wl-clipboard
      uv
      tree
      gdu
      fastfetch
      btop
      usbutils
      yazi
    ];
  };
}
