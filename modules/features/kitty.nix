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
        # background = "#171717";
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
