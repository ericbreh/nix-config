{...}: {
  flake.modules.nixos.logitech = {
    hardware.usb-modeswitch.enable = true;
  };
}
