{
  lib,
  config,
  ...
}: {
  options.keyd.enable = lib.mkEnableOption "Enable keyd";
  config = lib.mkIf config.keyd.enable {
    services.keyd = {
      enable = true;
      keyboards."builtin" = {
        ids = ["0001:0001"];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            rightcontrol = "capslock";
            space = "overload(nav, space)";
          };
          nav = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };
  };
}
