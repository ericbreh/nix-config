{inputs, ...}: {
  flake.modules.nixos.simracing = {
    hardware.usb-modeswitch.enable = true;

    services.udev.extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c262", MODE="0660", TAG+="uaccess"
    '';

    home-manager.sharedModules = [inputs.self.modules.homeManager.simracing];
  };

  flake.modules.homeManager.simracing = {pkgs, ...}: let
    g920Profile = ./g920.amgp;
    g920UniqueId = "030059d36d04000062c20000110100001133497620000ea5df5f4e821";
    antimicroxG920 = pkgs.writeShellScript "antimicrox-g920" ''
      set -eu
      settings="''${XDG_CONFIG_HOME:-$HOME/.config}/antimicrox/antimicrox_settings.ini"
      ${pkgs.python3}/bin/python3 - "$settings" "${g920Profile}" "${g920UniqueId}" <<'PY'
      import sys
      from pathlib import Path

      settings, profile, uid = sys.argv[1:]
      path = Path(settings)
      text = path.read_text() if path.exists() else "[General]\n\n[Controllers]\n"
      file_key = "Controller" + uid + "ConfigFile1"
      last_key = "Controller" + uid + "LastSelected"
      out = []
      seen_file = False
      seen_last = False
      for line in text.splitlines():
          if (
              line.startswith("Controller")
              and line.rstrip().endswith("g920.amgp")
              and uid not in line
          ):
              continue
          if line.startswith(file_key + "="):
              line = file_key + "=" + profile
              seen_file = True
          elif line.startswith(last_key + "="):
              line = last_key + "=" + profile
              seen_last = True
          out.append(line)
      if not any(line.strip() == "[Controllers]" for line in out):
          if out and out[-1] != "":
              out.append("")
          out.append("[Controllers]")
      if not seen_file:
          out.append(file_key + "=" + profile)
      if not seen_last:
          out.append(last_key + "=" + profile)
      path.parent.mkdir(parents=True, exist_ok=True)
      path.write_text("\n".join(out) + "\n")
      PY
      exec ${pkgs.antimicrox}/bin/antimicrox --tray --hidden
    '';
  in {
    home.packages = [pkgs.antimicrox];

    systemd.user.services.antimicrox = {
      Unit = {
        Description = "AntiMicroX G920 menu mapping";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = antimicroxG920;
        Restart = "on-failure";
        RestartSec = "3";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
