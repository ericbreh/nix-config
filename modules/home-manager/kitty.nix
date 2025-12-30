{
  lib,
  config,
  pkgs,
  ...
}: {
  options.home-manager.kitty.enable = lib.mkEnableOption "Enable kitty";
  config = lib.mkIf config.home-manager.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "MesloLGS Nerd Font Mono";
        size = 12;
      };
      keybindings = {
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+backspace" = "send_text all \\x17";
        "ctrl+delete" = "send_text all \\x1b[3;5~";
      };
      settings = {
        # background = "#171717";
        background_opacity = 0.5;
        hide_window_decorations = "yes";
        enable_audio_bell = "no";
        confirm_os_window_close = 2;
      };
    };
  };
}
