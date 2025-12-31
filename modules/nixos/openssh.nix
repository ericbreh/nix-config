{
  lib,
  config,
  ...
}: {
  options.openssh.enable = lib.mkEnableOption "Enable openssh";
  config = lib.mkIf config.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    services.fail2ban.enable = true;
  };
}
