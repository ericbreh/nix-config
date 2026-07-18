{inputs, ...}: {
  flake.modules.nixos.kitty = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.kitty];
  };

  flake.modules.homeManager.kitty = {
    programs.kitty = {
      enable = true;
      font = {
        name = "MesloLGS Nerd Font Mono";
        size = 12;
      };
      keybindings = {
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+c" = "copy_or_interrupt";
      };
      settings = {
        background = "#000000";
        foreground = "#cdcdcd";
        selection_background = "#252530";
        selection_foreground = "#cdcdcd";
        cursor = "#cdcdcd";

        color0 = "#252530";
        color1 = "#d8647e";
        color2 = "#7fa563";
        color3 = "#f3be7c";
        color4 = "#6e94b2";
        color5 = "#bb9dbd";
        color6 = "#aeaed1";
        color7 = "#cdcdcd";

        color8 = "#606079";
        color9 = "#e08398";
        color10 = "#99b782";
        color11 = "#f5cb96";
        color12 = "#8ba9c1";
        color13 = "#c9b1ca";
        color14 = "#bebeda";
        color15 = "#d7d7d7";

        background_opacity = 0.5;
        background_blur = 1;
        hide_window_decorations = "yes";
        enable_audio_bell = "no";
        confirm_os_window_close = 2;
        update_check_interval = 0;
      };
    };
  };
}
