{...}: {
  flake.modules.nixos.gnome = {
    services.xserver.enable = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
  };
}
