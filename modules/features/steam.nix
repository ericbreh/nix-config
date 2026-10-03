{...}: {
  flake.modules.nixos.steam = {
    hardware.usb-modeswitch.enable = true;

    services.udev.extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c262", MODE="0660", TAG+="uaccess"
    '';

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
