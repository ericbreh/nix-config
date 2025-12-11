{
  config,
  pkgs,
  ...
}: {
  programs.gnome-shell.enable = true;

  programs.gnome-shell.extensions = [
    {package = pkgs.gnomeExtensions.caffeine;}
    {package = pkgs.gnomeExtensions.brightness-control-using-ddcutil;}
    {package = pkgs.gnomeExtensions.clipboard-indicator;}
    {package = pkgs.gnomeExtensions.vitals;}
  ];

  home.packages = with pkgs; [
    ddcutil
    ffmpegthumbnailer
    ffmpeg
    libheif
    libheif.out
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
  ];
}
