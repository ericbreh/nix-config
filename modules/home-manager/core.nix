{
  lib,
  config,
  pkgs,
  ...
}: {
  options.core.enable = lib.mkEnableOption "Enable core";
  config = lib.mkIf config.core.enable {
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
      mgitstatus
      speedtest-go
    ];
  };
}
