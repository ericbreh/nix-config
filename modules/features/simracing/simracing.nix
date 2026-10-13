{inputs, ...}: {
  flake.modules.nixos.simracing = {
    hardware.usb-modeswitch.enable = true;

    services.udev.extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c262", MODE="0660", TAG+="uaccess"
    '';

    home-manager.sharedModules = [inputs.self.modules.homeManager.simracing];
  };

  flake.modules.homeManager.simracing = {pkgs, ...}: {
    home.packages = [pkgs.antimicrox];

    systemd.user.services.antimicrox = {
      Unit = {
        Description = "AntiMicroX G920 menu mapping";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = ''
          ${pkgs.antimicrox}/bin/antimicrox \
            --tray \
            --hidden \
            --profile ${./g920.amgp} \
            --profile-controller "Logitech G920 Driving Force Racing Wheel"
        '';
        Restart = "on-failure";
        RestartSec = "3";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
