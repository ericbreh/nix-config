{...}: {
  flake.modules.nixos.server-power = {
    services.logind = {
      settings = {
        Login = {
          AllowSuspend = false;
          AllowHibernation = false;
          AllowHybridSleep = false;
          AllowSuspendThenHibernate = false;
          HandleLidSwitch = "ignore";
        };
      };
    };
    services.tlp = {
      enable = true;
      settings = {
        STOP_CHARGE_THRESH_BAT0 = 55;
        START_CHARGE_THRESH_BAT0 = 45;
      };
    };
  };
}
